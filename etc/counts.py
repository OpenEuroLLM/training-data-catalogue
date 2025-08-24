import io;
import glob;
import gzip;
import json;
import multiprocessing as mp;
import os;
import re;
import sys;
import time;
from transformers import AutoTokenizer;
import zstandard as zstd;

def count_file(path, tokenizer = None, key = "text", write = True, force = False):

  directory, file = os.path.split(path);
  for _ in (".zstd", ".zst", ".gz", ".jsonl", ".json"):
    if file.endswith(_): file = file[:-len(_)];
  file = os.path.join(directory, "." + file + ".counts.json");
  if not force and os.path.isfile(file):
    with open(file) as _:
      return json.load(_);
    
  stream = None;
  if path.endswith(".zst") or path.endswith(".zstd"):
    decompressor = zstd.ZstdDecompressor();
    stream = decompressor.stream_reader(open(path, "rb"));
    stream = io.TextIOWrapper(stream, encoding = "utf-8", errors = "replace");
  elif path.endswith(".gz"):
    stream = gzip.open(path, mode = "rt", encoding = "utf-8", errors = "replace");
  else:
    print("count_file(): invalid input format {path}; exit.",
          file = sys.stderr)
    exit(1);

  print(f"count_file(): {path} ...", end = "", flush = True);
  if tokenizer is None:
    tokenizer = AutoTokenizer.from_pretrained("google/gemma-3-4b-it",
                                              trust_remote_code = True,
                                              use_fast = True);
  
  start = time.time();
  errors = [];  
  bytes = os.path.getsize(path);
  documents = segments = tokens = characters = 0;
  for i, line in enumerate(stream):
    try:
      text = json.loads(line)[key];
    except Exception as error:
      errors.append(i);
      print(error, file = sys.stderr);
      continue;
    documents += 1;
    segments += text.count("\n") + 1;
    tokens += len(tokenizer.tokenize(text));
    characters += len(text);
  print(f"{documents} documents.", end = "", flush = True);
  result = {"bytes": bytes, "documents": documents, "segments": segments,
            "tokens": tokens, "characters": characters,
            "errors": errors, "time": time.time() - start};
  if write:
    with open(file, "w", encoding="utf-8") as _:
      json.dump(result, _, indent = 2);
  return result;
      
def count_directory(path, pattern = "\\.jsonl\\.zstd$", cores = 1,
                    tokenizer = None, key = "text", force = False):

  start = time.time();
  result = {"files": 0, "bytes": 0,
            "documents": 0, "segments": 0, "tokens": 0, "characters": 0,
            "errors": 0};
  if tokenizer is None:
    tokenizer = AutoTokenizer.from_pretrained("google/gemma-3-4b-it",
                                              trust_remote_code = True,
                                              use_fast = True);
  with mp.Pool(cores) as pool:
    results = pool.starmap(count_file,
                           ((file, tokenizer, key, True, force)
                            for file in glob.glob(os.path.join(path, "*"))
                            if re.search(pattern, file)));
  for counts in results:
    for _ in ("bytes", "documents", "segments", "tokens", "characters"):
      result[_] += counts[_];
    result["errors"] += len(counts["errors"]);
    result["files"] += 1;
  with open(os.path.join(path, ".counts.json"),
            "w", encoding="utf-8") as stream:
    result["time"] = time.time() - start;
    json.dump(result, stream, indent = 2);
  return result;

def summarize(path, output = sys.stdout, format = "csv",
              sample = False, pattern = "\\.zst$", base = None):

  if isinstance(output, str):
    base = os.path.dirname(output);
    with open(output, "w") as output:
      return summarize(path, output, format, sample, pattern, base);
    
  prefix = "https://data.hplt-project.org/three/sorted";

  result = [];
  totals = {"bytes": 0, "documents": 0, "segments": 0,
            "tokens": 0, "characters": 0};
  multilingual, english = None, None;
  if format == "json":
    multilingual = open(os.path.join(base, "multilingual.map"),
                        "wt", encoding = "utf-8");
    english = open(os.path.join(base, "english.map"),
                   "wt", encoding = "utf-8");
  for file in sorted(glob.glob(os.path.join(path, "*/.counts.json"))):
    name = file.split(os.path.sep)[-2];
    with open(file) as _:
      counts = json.load(_);
      counts["name"] = name;
      documents = counts["documents"];
      tokens = counts["tokens"];
      characters = counts["characters"];
      counts["t/d"] = tokens / documents;
      counts["c/t"] = characters / tokens;
      counts.pop("errors", None);
      counts.pop("time", None);
      
      if sample:
        counts["samples"] = dict();
        for bin in range(0, 11):
          data = os.path.join(path, name, f"{bin}_1.jsonl.zst");
          if os.path.isfile(data):
            counts["samples"][bin] = [];
            decompressor = zstd.ZstdDecompressor();
            stream = decompressor.stream_reader(open(data, "rb"));
            stream = io.TextIOWrapper(stream, encoding = "utf-8", errors = "replace");
            for _ in range(0, 2):
              try:
                line = next(stream);
                counts["samples"][bin].append(json.loads(line)["text"]);
              except Exception:
                break;
              
      result.append(counts);
                
      if format == "csv":
        print("{}\t{}\t{}\t{}\t{}\t{:.2f}\t{}\t{:.2f}"
              "".format(name, counts["bytes"], documents, counts["segments"],
                        tokens, tokens / documents,
                        characters, characters / tokens),
              file = output);

      if format == "json":
        counts["urls"] = [];
        for _ in sorted(glob.glob(os.path.join(file[:-len("/.counts.json")], "*"))):
          if re.search(pattern, _):
            counts["urls"].append(prefix + "/" + name + "/" + os.path.basename(_));
        if base is not None:
          counts["map"] = prefix + "/" + name + ".map";
          with open(os.path.join(base, name + ".map"), "wt", encoding = "utf-8") as _:
            print("\n".join(counts["urls"]), file = _);
          if name in {"eng_Latn"}:
            print("\n".join(counts["urls"]), file = english);
          else:
            print("\n".join(counts["urls"]), file = multilingual);
          samples = {"samples": counts["samples"]};
          with open(os.path.join(base, name + ".json"), "wt", encoding = "utf-8") as _:
            json.dump(samples, _, indent = None, ensure_ascii = False);
          counts["samples"] = prefix + "/" + name + ".json";
          counts["md5"] = prefix + "/" + name + ".md5";
        json.dump(counts, output, indent = None, ensure_ascii = False);
        print(file = output);
        
      if format == "md":
        print("| {} | {:,} | {:,} | {:,} | {:,.1f} | {:,} |"
              "".format(name, documents, counts["segments"],
                        tokens, tokens / documents, characters),
              file = output);
      for _ in ["bytes", "documents", "segments", "tokens", "characters"]:
        totals[_] += counts[_];

  if multilingual is not None: multilingual.close();
  if english is not None: english.close();
  documents = totals["documents"];
  segments = totals["segments"];
  tokens = totals["tokens"];
  characters = totals["characters"];
  if format == "csv":
    print("Total\t{}\t{}\t{}\t{}\t{:.2f}\t{}\t{:.2f}"
          "".format(totals["bytes"], documents, segments,
                    tokens, tokens / documents,
                    characters, characters / tokens),
          file = output);
  if format == "md":
    print("| **Total** | {:,} | {:,} | {:,} | {:,.1f} | {:,} |"
          "".format(documents, segments, tokens,
                    tokens / documents, characters),
          file = output);
        
  return result;
