import io;
import glob;
import gzip;
import hashlib;
import json;
import multiprocessing as mp;
from operator import itemgetter;
import os;
import re;
import sys;
import time;
from urllib.parse import urlsplit;
import zstandard as zstd;

def index_file(path, text = "text", url = "u", level = 1):

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

  signatures = dict();
  if url is not None: domains = dict(); urls = dict();
  else: domains = urls = None;
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
      document = normalize.sub("", _[text]).lower();
      signature = hashlib.md5(document.encode("utf-8")).hexdigest();
      if url is not None:
        address = _[url];
        domain = urlsplit(address).netloc;
    except Exception as error:
      print(f"index_file(): #{i} decoding error: {error}.",
            file = sys.stderr);
      continue;
    index(signature, signatures);
    if url is not None:
      index(domain, domains);
      index(address, urls);

  def output(dictionary, suffix):
    name = os.path.join(directory, "." + file + suffix + ".zst");
    compressor = zstd.ZstdCompressor(level = 10, threads = 1);
    stream = compressor.stream_writer(open(name, "wb"));
    stream = io.TextIOWrapper(stream, encoding = "utf-8", errors = "replace");
    for _, __ in sorted(dictionary.items()):
      print("{}\t{}".format(_, __["n"]),
            end = "\t", file = stream);
      __.pop("n");
      json.dump(__, stream);
      print(file = stream);
    stream.close();

  for _ in (".zstd", ".zst", ".gz", ".jsonl", ".json"):
    if file.endswith(_): file = file[:-len(_)];
  output(signatures, ".signatures");
  if url is not None:
    output(domains, ".domains");
    output(urls, ".urls");

  return i + 1;
      
def index_directory(path, pattern = r"\.jsonl\.zst$", cores = 1,
                    text = "text", url = "u", level = 1, tree = False):

  def walk(path, pattern, tree):
    block = re.compile(r"/\.(?:domains|urls|signatures)\.zst$");
    if not os.path.isdir(path):
      print(f"merge.py: ignoring invalid path {path}.",
            file = sys.stderr);
      return [];
    result = [];
    for path in glob.glob(os.path.join(path, "*"), include_hidden = True):
      if tree and os.path.isdir(path):
        result += walk(path, pattern, tree);
      elif os.path.isfile(path) and pattern.search(path):
        if not block.search(path): result.append(path);
    return result;

  start = time.time();
  pattern = re.compile(pattern);
  files = walk(path, pattern, tree);
  print("index.py: reading {}.".format([file[len(path) + 1:] for file in files]));
  with mp.Pool(cores) as pool:
    counts = pool.starmap(index_file,
                          ((file, text, url, level) for file in files));
  print("index.py: processed {} files; {} documents; {:.2f} seconds."
        "".format(len(counts), sum(counts), time.time() - start));

  def connect(files):
    #
    # open the individual index files and read their first entry
    #
    inputs = [];
    for file in files:
      decompressor = zstd.ZstdDecompressor();
      stream = decompressor.stream_reader(open(file, "rb"));
      stream = io.TextIOWrapper(stream, encoding = "utf-8", errors = "replace");
      input = {"stream": stream, "file": file, "n": 0};
      key, count, input = parse(input);
      if key is None: continue;
      inputs.append((key, count, input));
    return inputs;

  def compress(suffix):
    #
    # create a compressed output stream
    #
    name = os.path.join(path, "." + suffix + ".zst");
    compressor = zstd.ZstdCompressor(level = 10, threads = cores);
    stream = compressor.stream_writer(open(name, "wb"));
    stream = io.TextIOWrapper(stream, encoding = "utf-8", errors = "replace");
    return stream;

  n = r = 0;
  for key in ["domains", "urls", "signatures"] if url is not None else ["signatures"]:
    pattern = re.compile(r"\.[^/]+\." + key + ".zst$");
    inputs = walk(path, pattern, tree);
    print("index.py: merging {}.".format([file[len(path) + 1:] for file in files]));
    inputs = connect(inputs);
    n += len(inputs);
    output = compress(key);
    r += merge(inputs, output);
    output.close();
    for _ in inputs: _["stream"].close();
  print("index.py: merged {} files; {} records; {:.2f} seconds."
        "".format(n, r, time.time() - start));

def parse(input):
  #
  # parse one tab-separated entry from an index file
  #
  line = next(input["stream"], None);
  if line is None:
    input["stream"].close();
    return None, None, None;
  input["n"] += 1;
  try:
    _ = line.find("\t");
    key = line[:_];
    line = line[_ + 1:];
    _ = line.find("\t");
    count = int(line[:_]);
    entry = json.loads(line[_ + 1:]);
  except Exception as error:
    print("index.py: aborting input from {file}, #{}: {error}."
          "".format(input["file"], input["n"], error),
          file = sys.stderr);
    input["stream"].close();
    return None, None, None;
  input["entry"] = entry;
  return key, count, input;

def merge(inputs, stream):
  #
  # sorted merge set of records from a set of input streams
  #
  n = 0;
  while len(inputs):
    #
    # _fix_me_ should use a genuine priority queue
    # 
    inputs.sort(key = itemgetter(0));
    key, count, input = inputs.pop();
    #
    # process other (currently visible) entries with the same key
    #
    while len(inputs) and inputs[-1][0] == key:
      #
      # merge count and payload of matching entry
      #
      match = inputs.pop();
      count += match[1];
      input["entry"].update(match[2]["entry"]);
      #
      # update for next record and re-queue, unless exhausted
      #
      match = parse(match[2]);
      if match[0] is None: continue;
      else: inputs.append(match);
    print(f"{key}\t{count}", end = "\t", file = stream);
    json.dump(input["entry"], stream);
    print(file = stream);
    n += 1;
    #
    # get next key, count, and entry from this input file;
    # re-insert into the priority queue, unless exhausted
    #
    key, count, input = parse(input);
    if key is None: continue;
    else: inputs.append((key, count, input));

  return n;

def compare_directories(left, right):
  1;
