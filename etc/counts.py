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

def count_file(path, tokenizer = None, key = "text", write = True):

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
  result = {"bytes": bytes, "documents": documents, "segments": segments,
            "tokens": tokens, "characters": characters,
            "errors": errors, "time": time.time() - start};
  if write:
    directory, file = os.path.split(path);
    for _ in (".zstd", ".zst", ".gz", ".jsonl", ".json"):
      if file.endswith(_): file = file[:-len(_)];
    with open(os.path.join(directory, "." + file + ".counts.json"),
              "w", encoding="utf-8") as stream:
      json.dump(result, stream, indent=2);
  return result;
      
def count_directory(path, pattern = "\\.zstd$", cores = 1, tokenizer = None, key = "text"):
  start = time.time();
  result = {"files": 0, "bytes": 0,
            "documents": 0, "segments": 0, "tokens": 0, "characters": 0};
  if tokenizer is None:
    tokenizer = AutoTokenizer.from_pretrained("google/gemma-3-4b-it",
                                              trust_remote_code = True,
                                              use_fast = True);
  with mp.Pool(cores) as pool:
    results = pool.starmap(count_file,
                           ((file, tokenizer, key)
                            for file in glob.glob(os.path.join(path, "*"))
                            if re.search(pattern, file)));
  for counts in results:
    for _ in ("bytes", "documents", "segments", "tokens", "characters"):
      result[_] += counts[_];
    result["files"] += 1;
  with open(os.path.join(path, ".counts.json"),
            "w", encoding="utf-8") as stream:
    result["time"] = time.time() - start;
    json.dump(result, stream, indent=2);
  return result;
