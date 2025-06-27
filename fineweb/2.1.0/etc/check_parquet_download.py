#!/usr/bin/env python3

import argparse
import csv
import os
import glob


def load_language_metadata(csv_path):
    metadata = {"train": {}, "test": {}}

    with open(csv_path) as f:
        reader = csv.DictReader(f)
        for row in reader:
            lang_code = row['subset']
            split = row['split']
            parquet_bytes = int(row['parquet_bytes'])

            metadata[split][lang_code] = parquet_bytes

    return metadata


def downloaded_size(local_dir):
    downloaded_bytes = 0
    for parquet_file in glob.glob(os.path.join(local_dir, "*.parquet")):
        downloaded_bytes += os.path.getsize(parquet_file)
    return downloaded_bytes


def check_downloads(output_dir, language_distribution):
    metadata = load_language_metadata(language_distribution)

    missing_files = 0
    size_mismatches = 0
    correct_files = 0

    for split in metadata:
        for lang_code, expected_size in metadata[split].items():
            local_dir = os.path.join(output_dir, "data", lang_code, split)

            if not os.path.exists(local_dir):
                print(f"Dataset {lang_code} {split} is missing in {local_dir}")
                missing_files += 1
            else:
                downloaded_bytes = downloaded_size(local_dir)
                if downloaded_bytes != expected_size:
                    print(f"Size mismatch for {lang_code} {split}: expected {expected_size}, got {downloaded_bytes}")
                    size_mismatches += 1
                else:
                    print(f"Dataset {lang_code} {split} is correct.")
                    correct_files += 1

    print("=" * 60)
    print("Summary:")
    print(f"{correct_files} files are correct.")
    print(f"{missing_files} files are missing.")
    print(f"{size_mismatches} files have size mismatches.")

if __name__ == "__main__":
    parser = argparse.ArgumentParser("Check FineWeb 2.1.0 dataset downloads")
    parser.add_argument("--output-dir", required=True, help="Output directory for downloaded data")
    parser.add_argument("--language-distribution", required=True, help="Path to fineweb2-language-distribution.csv")

    args = parser.parse_args()
    check_downloads(args.output_dir, args.language_distribution)