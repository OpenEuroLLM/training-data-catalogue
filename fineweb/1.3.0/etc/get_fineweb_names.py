#!/usr/bin/env python3

from datasets import get_dataset_config_names

names = get_dataset_config_names("HuggingFaceFW/fineweb")
print("\n".join(names))
