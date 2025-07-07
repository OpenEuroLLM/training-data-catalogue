def retrieve_files(path, pattern):
  import re;
  import requests;
  response = requests.get(f"https://huggingface.co/api/datasets/{path}");
  for file in response.json()["siblings"]:
    name = file["rfilename"];
    if re.search(pattern, name): print(name);
