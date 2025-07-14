#!/usr/bin/env python3

import argparse
import csv
import os
import glob


def load_crawl_list(path):
    crawls = {}
    with open(path) as f:
        for line in f:
            if not line:
                return

            crawl, gbsize, toksize = line.split("\t")
            if not toksize:
                raise ValueError("malformed crawl list file")

            crawls[crawl] = {"gbsize": float(gbsize), "gpt2_tokens": float(toksize)}
    return crawls


def downloaded_size(local_dir):
    downloaded_bytes = 0
    for parquet_file in glob.glob(os.path.join(local_dir, "*.parquet")):
        downloaded_bytes += os.path.getsize(parquet_file)
    return round(downloaded_bytes / 1024 / 1024 / 1024, 1)


def check_downloads(output_dir, crawl_list_path, delta_gib=10):
    crawls = load_crawl_list(crawl_list_path)

    missing_files = 0
    size_mismatches = 0
    correct_files = 0

    for ccsplit in crawls:
        local_dir = os.path.join(output_dir, "data", ccsplit)
        expected_size = crawls[ccsplit]["gbsize"]

        if not os.path.exists(local_dir):
            print(f"Dataset {ccsplit} is missing in {local_dir}")
            missing_files += 1
        else:
            downloaded_gbytes = downloaded_size(local_dir)
            if abs(downloaded_gbytes - expected_size) > delta_gib:
                print(f"Size mismatch for {ccsplit}: expected {expected_size}G,"
                      f"got {downloaded_gbytes}G")
                size_mismatches += 1
            else:
                print(f"Dataset {ccsplit} is correct.")
                correct_files += 1

    print("=" * 60)
    print("Summary:")
    print(f"{correct_files} files are correct.")
    print(f"{missing_files} files are missing.")
    print(f"{size_mismatches} files have size mismatches.")

if __name__ == "__main__":
    parser = argparse.ArgumentParser("Check FineWeb 1.3.0 dataset downloads")
    parser.add_argument("--output-dir", required=True, help="Output directory for downloaded data")
    parser.add_argument("--crawl-tsv", required=True, help="Path to a TSV file with a list of crawls to download and their expected sizes")

    args = parser.parse_args()
    check_downloads(args.output_dir, args.crawl_tsv)
