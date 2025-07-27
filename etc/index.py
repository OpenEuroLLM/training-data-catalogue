import io;
import glob;
import gzip;
import hashlib;
import json;
import multiprocessing as mp;
import os;
import re;
import sys;
import time;
from urllib.parse import urlsplit;
import zstandard as zstd;

def index_file(path, text = "text", url = "u", level = 1, write = True):

  stream = None;
  if path.endswith(".zst") or path.endswith(".zstd"):
    decompressor = zstd.ZstdDecompressor();
    stream = decompressor.stream_reader(open(path, "rb"));
    stream = io.TextIOWrapper(stream, encoding = "utf-8", errors = "replace");
  elif path.endswith(".gz"):
    stream = gzip.open(path, mode = "rt", encoding = "utf-8", errors = "replace");
  else:
    print("index_file(): invalid input format {path}; exit.",
          file = sys.stderr)
    exit(1);

  domains = dict(); urls = dict(); signatures = dict();
  normalize = re.compile(r"\W", re.IGNORECASE);
  directory, file = os.path.split(path);
  key = os.path.join(os.path.sep.join(directory.split(os.path.sep)[-level:]), file);

  def index(item, dictionary):
    if item in dictionary:
      _ = dictionary[item];
      _["n"] += 1;
      _[key].append(i);
    else:
      dictionary[item] = {"n": 1, key: [i]};

  for i, line in enumerate(stream):
    try:
      _ = json.loads(line);
      document = _[text];
      signature = hashlib.md5(normalize.sub("", document).encode("utf-8")).hexdigest();
      address = _[url];
      domain = urlsplit(address).netloc;
    except Exception as error:
      print(f"index_file(): #{i} decoding error: {error}.",
            file = sys.stderr);
      continue;
    index(domain, domains);
    index(address, urls);
    index(signature, signatures);

  if write:
    def output(dictionary, suffix):
      name = os.path.join(directory, "." + file + suffix + ".zst");
      compressor = zstd.ZstdCompressor(level = 10, threads = 1);
      stream = compressor.stream_writer(open(name, "wb"));
      stream = io.TextIOWrapper(stream, encoding = "utf-8", errors = "replace");
      for _, __ in sorted(dictionary.items()):
        print(f"{_}\t{__["n"]}", end = "\t", file = stream);
        __.pop("n");
        json.dump(__, stream);
        print(file = stream);
      stream.close();

    for _ in (".zstd", ".zst", ".gz", ".jsonl", ".json"):
      if file.endswith(_): file = file[:-len(_)];
    output(domains, ".domains");
    output(urls, ".urls");
    output(signatures, ".signatures");

    return i + 1;
  else:
    return domains, urls, signatures;
      
def index_directory(path, pattern = "\\.jsonl\\.zst$", cores = 1, text = "text", url = "u", level = 1):
  start = time.time();
  with mp.Pool(cores) as pool:
    counts = pool.starmap(index_file,
                          ((file, text, url, level)
                           for file in glob.glob(os.path.join(path, "*"))
                           if re.search(pattern, file)));
  print("index.py: {} files; {} documents; {:.2f} seconds."
        "".format(len(counts), sum(counts), time.time() - start));
    
