#!/usr/bin/env python3

import argparse
from huggingface_hub import snapshot_download


def main(dir_name):
    snapshot_download(
        "HuggingFaceFW/fineweb-2",
        repo_type="dataset",
        local_dir=dir_name,
        allow_patterns=[f"data/*"],
        max_workers=120)


if __name__ == "__main__":
    parser = argparse.ArgumentParser("download single language part of fineweb in the parquet format")
    parser.add_argument("--output-dir", help="Output directory", default=".")
    args = parser.parse_args()

    main(args.output_dir)
