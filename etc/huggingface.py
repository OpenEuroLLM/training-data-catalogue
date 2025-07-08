def retrieve_files(path, pattern):
  import re;
  import json, re, urllib.request;
  with urllib.request.urlopen(f"https://huggingface.co/api/datasets/{path}") as stream:
    for file in json.load(stream)["siblings"]:
      name = file["rfilename"];
      if re.search(pattern, name): print(name);
