#!/usr/bin/env python3

import argparse
from huggingface_hub import snapshot_download


def main(language_code, dir_name):
    snapshot_download(
        "HuggingFaceFW/fineweb-2",
        repo_type="dataset",
        local_dir=dir_name,
        allow_patterns=[f"data/{language_code}/*"],
        max_workers=16)


if __name__ == "__main__":
    parser = argparse.ArgumentParser("download single language part of fineweb in the parquet format")
    parser.add_argument("language_code", help="Language code (e.g. ces_Latn)")
    parser.add_argument("--output-dir", help="Output directory", default=".")
    args = parser.parse_args()

    main(args.language_code, args.output_dir)
