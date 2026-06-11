#!/usr/bin/env python

# -*- coding: utf-8; -*-

import argparse;
import glob;
import io;
import orjson;
import os;
from pathlib import Path;
import regex;
from subprocess import Popen, PIPE;
import sys;
import time;
import traceback;
import uuid;
import zstandard;

def now():
  return time.strftime("%H:%M:%S (%d-%b-%y)").lower();

def connect(path, mode, pipe, buffer):
  if not os.path.isfile(path):
    print("zstdconcat.py: invalid input file {}; exit"
          "".format(path),
          file = sys.stderr, flush = True);
    sys.exit(1);
  if pipe:
    if mode == "string":
      _ = Popen(["zstdcat", path], bufsize = buffer,
                stdout = PIPE, encoding = "utf-8", errors = "strict",
                stderr = sys.stdout);
    else:
      _ = Popen(["zstdcat", path], bufsize = buffer,
                stdout = PIPE, stderr = sys.stdout);
    return _.stdout;
  else:
    if mode == "string":
      _ = zstandard.open(path, "r", encoding = "utf-8", errors = "strict");
    else:
      _ = io.BufferedReader(zstandard.open(path, "rb"), buffer_size = buffer);
    return _;

def parse(chunk, trace, i):
  result = None;
  try:
    if isinstance(chunk, bytes): chunk = chunk.decode("utf-8", errors = "strict");
    result = orjson.loads(chunk);
  except UnicodeError as error:
    if trace > 1:
      print("[{}] zstdconcat.py: failed to decode bytes object {}; skip."
            "".format(now(), chunk),
            file = sys.stderr, flush = True);
  except Exception as error:
    if trace > 1:
      print("[{}] zstdconcat.py: failed to parse string {}; skip."
            "".format(now, chunk),
            file = sys.stderr, flush = True);
  return result;

NONWORD_REPLACE_PATTERN = regex.compile(r"[^\p{Word}\p{Zs}]|\d");
SPACE_PATTERN = regex.compile(r"\s\s+")

def lid(text, identity, model):
  if text in {None, ""}: return {"lang": None};
  if "openlid" in identity:
    text = text.strip().replace('\n', ' ').lower();
    text = SPACE_PATTERN.sub(" ", text);
    text = NONWORD_REPLACE_PATTERN.sub("", text);
  else:
    text = text.strip().replace("\n", " ");
  result = model.predict(text = text, k = 3, threshold = 0.0,
                         on_unicode_error = "strict");
  return {"lang": [_.removeprefix("__label__") for _ in result[0]],
          "prob": [float(round(_, 4)) for _ in result[1]]};

def main():

  start = time.time();

  parser = argparse.ArgumentParser(description = "HPLT ");
  parser.add_argument("--cores", type = int, default = 1);
  parser.add_argument("--level", type = int, default = 3);
  parser.add_argument("--size", type = int, default = 1e11);
  parser.add_argument("--buffer", type = int, default = 4 * 1024 ** 2);
  parser.add_argument("--pipe", action = "store_true");
  parser.add_argument("--mode", type = str, default = "bytes");
  parser.add_argument("--filter", type = str, default = None);
  parser.add_argument("--align", type = str);
  parser.add_argument("--uuid", action = "store_true");
  parser.add_argument("--lid", action = "append", default = []);
  parser.add_argument("--rename", action = "append", default = []);
  parser.add_argument("--compress", type = str);
  parser.add_argument("--trace", action = "count", default = 0);
  parser.add_argument("inputs", nargs = "*");
  arguments = parser.parse_args();

  io.DEFAULT_BUFFER_SIZE = arguments.buffer;
  outputs = dict();
  if ((arguments.align or arguments.uuid
       or len(arguments.lid) or len(arguments.rename))
      and arguments.mode != "json"):
    print("zstdconcat.py: --align, --lid, --uuid, or --rename require JSON --mode; exit.",
          file = sys.stderr, flush = True);
    sys.exit(1);

  #
  # increase output buffer size
  #
  mode = arguments.mode;
  if arguments.compress is not None:
    output = io.BufferedWriter(zstandard.open(arguments.compress, "wb"),
                               buffer_size = arguments.buffer);
  else:
    if mode in {"bytes", "json"}:
      output = open(1, "wb", buffering = arguments.buffer, closefd = False);
    else:
      output = open(1, "w", encoding = "utf-8",
                    buffering = arguments.buffer, closefd = False);
    
  filter = None;
  if arguments.filter is not None:
    filter = connect(arguments.filter, mode,
                     arguments.pipe, arguments.buffer);
  
  if arguments.trace > 0:
    print("[{}] zstdconcat.py: {} {} input files(s)."
          "".format(now(),
                     "filtering" if filter is not None else "reading",
                    len(arguments.inputs)),
          file = sys.stderr, flush = True);
  #
  # initialize fastText model(s) if requested
  #
  lids = [];
  if len(arguments.lid):
    import fasttext;
    cache = os.path.join(Path.home(), ".cache", "hplt");
  for identity in arguments.lid:
    _ = os.path.join(cache, identity + ".bin");
    if not os.path.isfile(_):
      print("zstdconcat.py: missing model file for {}; exit."
            "".format(identity),
            file = sys.stderr, flush = True);
      sys.exit(1);
    try:
      model = fasttext.load_model(_);
      lids.append((identity, model));
    except:
      print("zstdconcat.py: failed to initialize LID {}; exit."
            "".format(identity),
            file = sys.stderr, flush = True);
      sys.exit(1);

  rename = dict();
  if len(arguments.rename):
    for _ in arguments.rename:
      try:
        old, new = _.split(":");
        rename[old] = new;
      except Exception as error:
        print("zstdconcat.py: error parsing --rename {}; exit"
              "".format(_),
              file = sys.stderr, flush = True);
        if arguments.trace > 0:
          print("".join(traceback.format_exception(error)),
                file = sys.stderr, flush = True);
        sys.exit(1);
        
  #
  # iterate over files provided on command line
  #
  streams = [connect(_, mode, arguments.pipe, arguments.buffer)
             for _ in arguments.inputs];
  #
  # process one document at a time, aligned across multiple files
  #
  i, n, f, s = 0, len(streams), 0, 0;
  if n:
    for i, line in enumerate(streams[0]):
      if not line.startswith("{" if mode == "string" else b"{"):
        print("zstdconcat.py: invalid JSON object {} ({}: #{}); exit"
              "".format(line, arguments.inputs[0], i),
              file = sys.stderr, flush = True);
        sys.exit(1);
      chunks = [];
      if filter is not None:
        _ = filter.readline();
        if not len(_):
          print("zstdconcat.py: premature end of file on {} (#{}); exit"
          "".format(arguments.filter, i),
          file = sys.stderr, flush = True);
          sys.exit(1);
        if not _.startswith("{" if mode == "string" else b"{"):
          print("zstdconcat.py: invalid JSON object {} ({}: #{}); exit"
                "".format(_, arguments.filter, i),
                file = sys.stderr, flush = True);
          sys.exit(1);
        if not ("true" if mode == "string" else b"true") in _:
          for stream in streams[1:]: stream.readline();
          f += 1;
          continue;
      #
      # collect and massage all line-aligned chunks
      #
      line = line.rstrip();
        
      if mode == "json":
        chunk, align = parse(line, arguments.trace, i), None;
        if arguments.align is not None:
          if arguments.align not in chunk:
            print("zstdconcat.py: missing --align key {} on {} (#{}); exit"
                  "".format(arguments.align, arguments.inputs[0], i),
                  file = sys.stderr, flush = True);
            sys.exit(1);
          else: align = chunk[arguments.align];
        chunks.append(chunk);
      elif n > 1: chunks.append(line[:-1]);
      else: chunks.append(line);
      if not len(line) or chunks[0] is None:
        print("zstdconcat.py: premature end of file on {} (#{}); exit"
              "".format(arguments.inputs[0], i),
              file = sys.stderr, flush = True);
        sys.exit(1);
      for j, stream in enumerate(streams[1:]):
        _ = stream.readline();
        if not _.startswith("{" if mode == "string" else b"{"):
          print("zstdconcat.py: invalid JSON object {} ({}: #{}); exit"
                "".format(_, arguments.inputs[j + 1], i),
                file = sys.stderr, flush = True);
          sys.exit(1);
        if mode == "json":
          chunk = parse(_, arguments.trace, i);
          if arguments.align is not None:
            if arguments.align not in chunk:
              print("zstdconcat.py: missing --align key {} on {} (#{}); exit"
                    "".format(arguments.align, arguments.inputs[j + 1], i),
                    file = sys.stderr, flush = True);
              sys.exit(1);
            elif chunk[arguments.align] != align:
              print("zstdconcat.py: --align {} mismatch on {} (#{}: {} vs. {}); exit"
                    "".format(arguments.align, arguments.inputs[j + 1], i,
                              align, chunk[arguments.align]),
                    file = sys.stderr, flush = True);
              sys.exit(1);
            else: chunk.pop(arguments.align);
          chunks.append(chunk);
        else:
          #
          # avoid spurious commas before empty JSON objects
          #
          if len(chunks[-1]) > 1 and len(_) > 3:
            chunks.append("," if mode == "string" else b",");
          if j < n - 2:
            if len(_) > 3: chunks.append(_.rstrip()[1:-1]);
          else: chunks.append(_.rstrip()[1:]);
        if not len(_) or chunks[-1] is None:
          print("zstdconcat.py: premature end of file on {} (#{}); exit"
                "".format(arguments.inputs[j + 1], i),
                file = sys.stderr, flush = True);
          sys.exit(1);
      #
      # finally, combine into one json representation, with minimal copying
      #
      if mode == "json":
        if None in chunks:
          s += 1;
        else:
          result = chunks.pop(0);
          for _ in chunks: result |= _;
      else:
        result = ("" if mode == "string" else b"").join(chunks);

      #
      # enforce renaming(s), if requested
      #
      for old, new in rename.items():
        try:
          result[new] = result.pop(old);
        except Exception as error:
          print("zstdconcat.py: error in renaming {} (#{}); exit"
                "".format(old, i),
                file = sys.stderr, flush = True);
          if arguments.trace > 0:
            print("".join(traceback.format_exception(error)),
                  file = sys.stderr, flush = True);
          sys.exit(1);
      
      #
      # optionally, ingest a (hopefully unique) UUID
      #
      if arguments.uuid: result["uuid"] = str(uuid.uuid4());
      
      #
      # optionally, add LID annotation(s) (to be validated)
      #
      if len(lids):
        try:
          for identity, model in lids:
            result[identity] = lid(result["text"], identity, model);
        except Exception as error:
          print("zstdconcat.py: error in lid {} (#{}); exit"
                "".format(identity, i),
                file = sys.stderr, flush = True);
          if arguments.trace > 0:
            print("".join(traceback.format_exception(error)),
                  file = sys.stderr, flush = True);
          sys.exit(1);

      #
      # finally, write out result, either to our compressed or plain stream
      #
      if mode == "json":
        output.write(orjson.dumps(result, option = orjson.OPT_APPEND_NEWLINE));
      else:
        output.write(result + ("\n" if mode == "string" else b"\n"));

  #
  # wrap up: close all output streams
  #
  for _ in streams: _.close();
  if filter is not None: filter.close();
  output.close();
  for _ in outputs.values(): _.close();
  if arguments.trace > 0:
    print("[{}] zstdconcat.py: processed {} {}{}input lines(s); {:.2f} seconds."
          "".format(now(), i + 1,
                    f"(- {f} filtered) " if arguments.filter else "",
                    f"(- {s} skipped) " if s > 0 else "",
                    time.time() - start),
          file = sys.stderr, flush = True);
  sys.exit(0);

if __name__ == "__main__":
  main();
