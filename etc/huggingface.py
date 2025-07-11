def api_retrieve_files(path, revision, pattern):
  import json, re, urllib.request;
  with urllib.request.urlopen(f"https://huggingface.co/api/datasets/{path}/revision/${revision}") as stream:
    for file in json.load(stream)["siblings"]:
      name = file["rfilename"];
      if re.search(pattern, name): print(name);
