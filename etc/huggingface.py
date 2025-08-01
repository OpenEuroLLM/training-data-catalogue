import json;
import re;
import urllib.request;

def api_retrieve_files(path, revision, pattern):
  with urllib.request.urlopen(f"https://huggingface.co/api/datasets/{path}/revision/{revision}") as stream:
    for file in json.load(stream)["siblings"]:
      name = file["rfilename"];
      if pattern is None or re.search(pattern, name): print(name);

def datasets_retrieve_configs(path, revision, pattern):
  from datasets import get_dataset_config_names;
  configs = get_dataset_config_names(path, revision);
  for config in configs:
    if pattern is None or re.search(pattern, config): print(config);

