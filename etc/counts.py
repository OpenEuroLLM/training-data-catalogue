from collections import Counter;
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

ROOT = "/appl/local/openeurollm/training/catalogue";
LANGUAGES = {"als_Latn", "bos_Latn", "bul_Cyrl", "cat_Latn", "ces_Latn",
             "dan_Latn", "deu_Latn", "ekk_Latn", "ell_Grek", "eng_Latn",
             "est_Latn", "eus_Latn", "fin_Latn", "fra_Latn", "gle_Latn",
             "glg_Latn", "hrv_Latn", "hun_Latn", "isl_Latn", "ita_Latn",
             "kat_Geor", "lav_Latn", "lit_Latn", "ltg_Latn", "lvs_Latn",
             "mkd_Cyrl", "mlt_Latn", "nld_Latn", "nno_Latn", "nob_Latn",
             "nor_Latn", "pol_Latn", "por_Latn", "ron_Latn", "slk_Latn",
             "slv_Latn", "spa_Latn", "sqi_Latn", "srp_Cyrl", "srp_Latn",
             "swe_Latn", "tur_Latn", "ukr_Cyrl"};
NEMOTRON = {"high/actual", "medium-high/actual", "medium/actual",
            "medium-low/actual", "low/actual",
            "high/synthetic/distill", "high/synthetic/diverse_qa_pairs",
            "high/synthetic/extract_knowledge", "high/synthetic/knowledge_list",
            "high/synthetic/wrap_medium", "low/synthetic/wrap_medium"};
HPLT = dict();
HPLT["3.0"] = {"gug_Latn": "Based on human data inspection via HPLT Analytics, this dataset appears to exhibit poor language identification; a large proportion of documents actually appear to comprise other languages, notably Spanish.",
               "kas_Deva": "Based on human data inspection via HPLT Analytics, an unusually high proportion of this dataset appears to comprise adult content.",
               "lij_Latn": "Based on human data inspection via HPLT Analytics, this dataset was further filtered for frequent foreign-language domains in mid-October 2025.",
               "szl_Latn": "Based on human data inspection via HPLT Analytics, this dataset was further filtered for frequent foreign-language domains in mid-October 2025."};

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

  print(f"count_file(): {path}.", flush = True);
  if tokenizer is None:
    tokenizer = AutoTokenizer.from_pretrained("google/gemma-3-4b-it",
                                              trust_remote_code = True,
                                              use_fast = True);
  
  start = time.time();
  errors = [];  
  bytes = os.path.getsize(path);
  documents = segments = tokens = characters = 0;
  keys = Counter();
  for i, line in enumerate(stream):
    try:
      _ = json.loads(line);
      text = _[key];
      keys.update(_.keys());
    except Exception as error:
      errors.append(i);
      print(error, file = sys.stderr);
      continue;
    documents += 1;
    segments += text.count("\n") + 1;
    tokens += len(tokenizer.tokenize(text));
    characters += len(text);
  result = {"bytes": bytes, "documents": documents, "segments": segments,
            "tokens": tokens, "characters": characters, "keys": dict(keys),
            "errors": errors, "time": time.time() - start};
  if write:
    with open(file, "w", encoding = "utf-8") as _:
      json.dump(result, _, indent = 2);
  return result;
      
def count_directory(path, pattern = "\\.jsonl\\.zstd$", cores = 1,
                    tokenizer = None, key = "text", force = False):

  result = {"files": 0, "bytes": 0,
            "documents": 0, "segments": 0, "tokens": 0, "characters": 0,
            "time": 0, "errors": 0};
  keys = Counter();
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
    for _ in ("bytes", "documents", "segments", "tokens", "characters", "time"):
      result[_] += counts[_];
    if "keys" in counts: keys.update(counts["keys"]);
    result["errors"] += len(counts["errors"]);
    result["files"] += 1;
  d = counts["documents"];
  required = list(); optional = list();
  for key, n in counts["keys"].items():
    if n == d:
      if key not in required: required.append(key);
    else:
      if key not in optional: optional.append(key);
  result["keys"] = {"required": required, "optional": optional};
  with open(os.path.join(path, ".counts.json"),
            "w", encoding="utf-8") as stream:
    json.dump(result, stream, indent = 2);
  return result;

def summarize(path, output = sys.stdout, format = "csv", sample = False,
              languages = None, partition = None, warning = None,
              pattern = "\\.zst$", base = None):
  #
  # to reflect different directory layouts, the .partition. argument can take
  # various forms:
  # + None: use all immediate sub-directories, e.g. one per language or crawl
  # + string: use immediate sub-directories plus path suffix (e.g. "train");
  # + list of strings: use specified sub-directories, e.g. ["high/actual", ...]
  # + "**": no meaningful partitions, recursively search for count files.
  #
  if base is None and isinstance(output, str):
    base = os.path.dirname(output);
    with open(output, "w") as output:
      return summarize(path, output, format, sample,
                       languages, partition, warning,
                       pattern, base);
    
  prefix = "https://data.hplt-project.org/three/sorted";

  result = [];
  totals = {"bytes": 0, "documents": 0, "segments": 0,
            "tokens": 0, "characters": 0};
  required = list(); optional = list();
  multilingual = None;
  if format == "json":
    multilingual = open(os.path.join(base, "multilingual.map"),
                        "wt", encoding = "utf-8");
  if partition is None or partition == "":
    files = glob.glob(os.path.join(path, "*", ".counts.json"));
    offset = -2;
  elif partition == "**":
    files = glob.glob(os.path.join(path, "**", ".counts.json"),
                      recursive = True);
    offset = 0;
  elif isinstance(partition, str):
    files = glob.glob(os.path.join(path, "*", partition, ".counts.json"));
    offset = -2 - len(partition.split(os.path.sep));
  else:
    files = [];
    for _ in partition:
      files.append(os.path.join(path, _, ".counts.json"));
      offset = None;
      
  for i, file in enumerate(sorted(files)):
    if offset == 0:
      name = file[len(path) + 1:-len(".counts.json") - 1];
    else:
      name = file.split(os.path.sep)[offset] if offset is not None else partition[i];
    if languages is not None and name not in languages: continue;
    with open(file) as _:
      counts = json.load(_);
      counts["name"] = name;
      documents = counts["documents"];
      tokens = counts["tokens"];
      characters = counts["characters"];
      counts["t/d"] = tokens / documents;
      counts["c/t"] = characters / tokens;
      if "errors" in counts and counts["errors"] > 0:
        print("summarize(): {} errors in {}."
              "".format(counts["errors"], file),
              file = sys.stderr, flush = True);
      counts.pop("errors", None);
      counts.pop("time", None);
      if warning is not None and name in warning:
        counts["warning"] = warning[name];
      
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
          if name not in {"eng_Latn"}:
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
      if "keys" in counts:
        for _ in counts["keys"]["required"]:
          if _ not in optional and _ not in required: required.append(_);
        for _ in counts["keys"]["optional"]:
          if _ not in optional: optional.append(_);

  if multilingual is not None: multilingual.close();
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
    if len(required) or len(optional):
      print(file = output);
      for _ in required:
        print(f"| {_} | required |  |", file = output);
      for _ in optional:
        print(f"| {_} | optional |  |", file = output);
  return result;
