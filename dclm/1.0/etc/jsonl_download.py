#!/usr/bin/env python3

import argparse
from huggingface_hub import snapshot_download, HfFileSystem


def list_all_files():
    fs = HfFileSystem()
    files = fs.glob("datasets/mlfoundations/dclm-baseline-1.0/*/*/*.jsonl.zst", detail=True)
    return files


def main(output_dir, max_workers, num_attempts=1, sleep_interval=0):
    files = list_all_files()
    for file in files:
        print(f"{file['name']}, {file['size']}")




if __name__ == "__main__":
    parser = argparse.ArgumentParser("Download DCLM-baseline 1.0 dataset")
    parser.add_argument(
        "--output-dir", required=True,
        help="Output directory (data/ subdir will be created)")
    parser.add_argument(
        "--max-workers", type=int, default=64,
        help="Maximum number of workers in snapshot_download (default: 64)")

    args = parser.parse_args()
    main(args.output_dir, args.max_workers) #, args.num_attempts,args.sleep_interval)
