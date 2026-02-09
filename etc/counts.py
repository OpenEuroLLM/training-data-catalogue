from collections import Counter
import io
import glob
import gzip
import json
import multiprocessing as mp
import os
import re
import sys
import time
from transformers import AutoTokenizer
import zstandard as zstd

ROOT = "/appl/local/openeurollm/training/catalogue"
LANGUAGES = {
    "als_Latn", "bos_Latn", "bul_Cyrl", "cat_Latn", "ces_Latn",
    "dan_Latn", "deu_Latn", "ekk_Latn", "ell_Grek", "eng_Latn",
    "est_Latn", "eus_Latn", "fin_Latn", "fra_Latn", "gle_Latn",
    "glg_Latn", "hrv_Latn", "hun_Latn", "isl_Latn", "ita_Latn",
    "kat_Geor", "lav_Latn", "lit_Latn", "ltg_Latn", "lvs_Latn",
    "mkd_Cyrl", "mlt_Latn", "nld_Latn", "nno_Latn", "nob_Latn",
    "nor_Latn", "pol_Latn", "por_Latn", "ron_Latn", "slk_Latn",
    "slv_Latn", "spa_Latn", "sqi_Latn", "srp_Cyrl", "srp_Latn",
    "swe_Latn", "tur_Latn", "ukr_Cyrl"
}
NEMOTRON = {
    "high/actual", "medium-high/actual", "medium/actual",
    "medium-low/actual", "low/actual",
    "high/synthetic/distill", "high/synthetic/diverse_qa_pairs",
    "high/synthetic/extract_knowledge", "high/synthetic/knowledge_list",
    "high/synthetic/wrap_medium", "low/synthetic/wrap_medium"
}
HPLT = {}
HPLT["3.0"] = {
    "gug_Latn": "Based on human data inspection via HPLT Analytics, this dataset appears to exhibit poor language identification; a large proportion of documents actually appear to comprise other languages, notably Spanish.",
    "kas_Deva": "Based on human data inspection via HPLT Analytics, an unusually high proportion of this dataset appears to comprise adult content.",
    "lij_Latn": "Based on human data inspection via HPLT Analytics, this dataset was further filtered for frequent foreign-language domains in mid-October 2025.",
    "szl_Latn": "Based on human data inspection via HPLT Analytics, this dataset was further filtered for frequent foreign-language domains in mid-October 2025."
}

def count_file(path, tokenizer=None, key="text", write=True, force=False):
    directory, file_name = os.path.split(path)
    for ext in (".zstd", ".zst", ".gz", ".jsonl", ".json"):
        if file_name.endswith(ext):
            file_name = file_name[:-len(ext)]
    output_file = os.path.join(directory, "." + file_name + ".counts.json")
    
    if not force and os.path.isfile(output_file):
        with open(output_file) as f:
            return json.load(f)
    
    stream = None
    fh = None
    try:
        if path.endswith(".zst") or path.endswith(".zstd"):
            decompressor = zstd.ZstdDecompressor()
            fh = open(path, "rb")
            stream = io.TextIOWrapper(decompressor.stream_reader(fh), encoding="utf-8", errors="replace")
        elif path.endswith(".gz"):
            stream = gzip.open(path, mode="rt", encoding="utf-8", errors="replace")
        else:
            print(f"count_file(): invalid input format {path}; exit.", file=sys.stderr)
            sys.exit(1)

        print(f"count_file(): {path}.", flush=True)
        if tokenizer is None:
            tokenizer = AutoTokenizer.from_pretrained(
                "google/gemma-3-4b-it",
                trust_remote_code=True,
                use_fast=True
            )
    
        start = time.time()
        errors = []
        file_bytes = os.path.getsize(path)
        documents = segments = tokens = characters = 0
        keys = Counter()
        
        for i, line in enumerate(stream):
            try:
                data = json.loads(line)
                text = data[key]
                keys.update(data.keys())
            except Exception as error:
                errors.append(i)
                print(error, file=sys.stderr)
                continue
            documents += 1
            segments += text.count("\n") + 1
            tokens += len(tokenizer.tokenize(text))
            characters += len(text)
            
        result = {
            "bytes": file_bytes,
            "documents": documents,
            "segments": segments,
            "tokens": tokens,
            "characters": characters,
            "keys": dict(keys),
            "errors": errors,
            "time": time.time() - start
        }
        
        if write:
            with open(output_file, "w", encoding="utf-8") as f:
                json.dump(result, f, indent=2)
        return result
    finally:
        if stream and hasattr(stream, "close"):
            stream.close()
        if fh:
            fh.close()

def count_directory(path, pattern=r"\.jsonl\.zstd$", cores=1,
                    tokenizer=None, key="text", force=False):
    result = {
        "files": 0, "bytes": 0,
        "documents": 0, "segments": 0, "tokens": 0, "characters": 0,
        "time": 0, "errors": 0
    }
    all_keys = Counter()
    
    if tokenizer is None:
        tokenizer = AutoTokenizer.from_pretrained(
            "google/gemma-3-4b-it",
            trust_remote_code=True,
            use_fast=True
        )
        
    with mp.Pool(cores) as pool:
        file_list = [
            f for f in glob.glob(os.path.join(path, "*"))
            if re.search(pattern, f)
        ]
        results = pool.starmap(
            count_file,
            ((f, tokenizer, key, True, force) for f in file_list)
        )
        
    for counts in results:
        for metric in ("bytes", "documents", "segments", "tokens", "characters", "time"):
            result[metric] += counts[metric]
        if "keys" in counts:
            all_keys.update(counts["keys"])
        result["errors"] += len(counts["errors"])
        result["files"] += 1
        
    total_docs = result["documents"]
    required = []
    optional = []
    for k, n in all_keys.items():
        if n == total_docs:
            if k not in required:
                required.append(k)
        else:
            if k not in optional:
                optional.append(k)
                
    result["keys"] = {"required": required, "optional": optional}
    
    with open(os.path.join(path, ".counts.json"), "w", encoding="utf-8") as stream:
        json.dump(result, stream, indent=2)
    return result

def summarize(path, output=sys.stdout, format="csv", sample=False,
              languages=None, partition=None, warning=None,
              pattern=r"\.zst$", base=None):
    #
    # to reflect different directory layouts, the .partition. argument can take
    # various forms:
    # + None: use all immediate sub-directories, e.g. one per language or crawl
    # + string: use immediate sub-directories plus path suffix (e.g. "train");
    # + list of strings: use specified sub-directories, e.g. ["high/actual", ...]
    # + "**": no meaningful partitions, recursively search for count files.
    #
    if base is None and isinstance(output, str):
        base = os.path.dirname(output)
        with open(output, "w") as output_stream:
            return summarize(
                path, output_stream, format, sample,
                languages, partition, warning,
                pattern, base
            )
    
    prefix = "https://data.hplt-project.org/three/sorted"

    result = []
    totals = {
        "bytes": 0, "documents": 0, "segments": 0,
        "tokens": 0, "characters": 0
    }
    required = []
    optional = []
    multilingual = None
    
    if format == "json":
        multilingual = open(
            os.path.join(base, "multilingual.map"),
            "wt", encoding="utf-8"
        )
        
    if partition is None or partition == "":
        files = glob.glob(os.path.join(path, "*", ".counts.json"))
        offset = -2
    elif partition == "**":
        files = glob.glob(os.path.join(path, "**", ".counts.json"), recursive=True)
        offset = 0
    elif isinstance(partition, str):
        files = glob.glob(os.path.join(path, "*", partition, ".counts.json"))
        offset = -2 - len(partition.split(os.path.sep))
    else:
        files = []
        for p in partition:
            files.append(os.path.join(path, p, ".counts.json"))
        offset = None
      
    for i, file_path in enumerate(sorted(files)):
        if offset == 0:
            name = file_path[len(path) + 1:-len(".counts.json") - 1]
        else:
            name = file_path.split(os.path.sep)[offset] if offset is not None else partition[i]
            
        if languages is not None and name not in languages:
            continue
            
        with open(file_path) as f:
            counts = json.load(f)
            
        counts["name"] = name
        documents = counts["documents"]
        tokens = counts["tokens"]
        characters = counts["characters"]
        counts["t/d"] = tokens / documents
        counts["c/t"] = characters / tokens
        
        if "errors" in counts and counts["errors"] > 0:
            print(f"summarize(): {counts['errors']} errors in {file_path}.",
                  file=sys.stderr, flush=True)
            
        counts.pop("errors", None)
        counts.pop("time", None)
        
        if warning is not None and name in warning:
            counts["warning"] = warning[name]
      
        if sample:
            counts["samples"] = {}
            for bin_idx in range(0, 11):
                data = os.path.join(path, name, f"{bin_idx}_1.jsonl.zst")
                if os.path.isfile(data):
                    counts["samples"][bin_idx] = []
                    decompressor = zstd.ZstdDecompressor()
                    with open(data, "rb") as fh:
                        stream = decompressor.stream_reader(fh)
                        stream = io.TextIOWrapper(stream, encoding="utf-8", errors="replace")
                        for _ in range(0, 2):
                            try:
                                line = next(stream)
                                counts["samples"][bin_idx].append(json.loads(line)["text"])
                            except Exception:
                                break
              
        result.append(counts)
                
        if format == "csv":
            print(f"{name}\t{counts['bytes']}\t{documents}\t{counts['segments']}\t"
                  f"{tokens}\t{tokens/documents:.2f}\t"
                  f"{characters}\t{characters/tokens:.2f}",
                  file=output)

        if format == "json":
            counts["urls"] = []
            parent_dir = file_path[:-len("/.counts.json")]
            for f in sorted(glob.glob(os.path.join(parent_dir, "*"))):
                if re.search(pattern, f):
                    counts["urls"].append(prefix + "/" + name + "/" + os.path.basename(f))
            
            if base is not None:
                counts["map"] = prefix + "/" + name + ".map"
                with open(os.path.join(base, name + ".map"), "wt", encoding="utf-8") as f:
                    print("\n".join(counts["urls"]), file=f)
                if name not in {"eng_Latn"}:
                    print("\n".join(counts["urls"]), file=multilingual)
                
                samples_data = {"samples": counts["samples"]}
                with open(os.path.join(base, name + ".json"), "wt", encoding="utf-8") as f:
                    json.dump(samples_data, f, indent=None, ensure_ascii=False)
                
                counts["samples"] = prefix + "/" + name + ".json"
                counts["md5"] = prefix + "/" + name + ".md5"
                
            json.dump(counts, output, indent=None, ensure_ascii=False)
            print(file=output)
        
        if format == "md":
            print(f"| {name} | {documents:,} | {counts['segments']:,} | {tokens:,} | "
                  f"{tokens/documents:,.1f} | {characters:,} |",
                  file=output)

        for metric in ["bytes", "documents", "segments", "tokens", "characters"]:
            totals[metric] += counts[metric]
            
        if "keys" in counts:
            for k in counts["keys"]["required"]:
                if k not in optional and k not in required:
                    required.append(k)
            for k in counts["keys"]["optional"]:
                if k not in optional:
                    optional.append(k)

    if multilingual is not None:
        multilingual.close()
        
    documents = totals["documents"]
    segments = totals["segments"]
    tokens = totals["tokens"]
    characters = totals["characters"]
    
    if format == "csv":
        print(f"Total\t{totals['bytes']}\t{documents}\t{segments}\t"
              f"{tokens}\t{tokens/documents:.2f}\t"
              f"{characters}\t{characters/tokens:.2f}",
              file=output)
              
    if format == "md":
        print(f"| **Total** | {documents:,} | {segments:,} | {tokens:,} | "
              f"{tokens/documents:,.1f} | {characters:,} |",
              file=output)
        if len(required) or len(optional):
            print(file=output)
            for k in required:
                print(f"| {k} | required |  |", file=output)
            for k in optional:
                print(f"| {k} | optional |  |", file=output)
                
    return result
