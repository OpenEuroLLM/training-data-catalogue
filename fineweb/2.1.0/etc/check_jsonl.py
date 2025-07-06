#!/usr/bin/env python3

import argparse
import os
import csv
import glob


def load_language_metadata(csv_path):
    metadata = {"train": {}, "test": {}}

    with open(csv_path) as f:
        reader = csv.DictReader(f)
        for row in reader:
            lang_code = row['subset']
            split = row['split']
            documents = int(row["documents"])

            metadata[split][lang_code] = documents

    return metadata


def main(output_dir, language_distribution_csv):
    metadata = load_language_metadata(language_distribution_csv)

    missing_dirs = 0
    missing_jsonlines = 0
    missing_linecount = 0
    size_mismatches = 0
    correct_files = 0

    for split in metadata:

        for lang_code, lines_expected in metadata[split].items():
            if lang_code.endswith("_removed"):
                continue

            local_dir = os.path.join(output_dir, "data", lang_code, split)

            if not os.path.exists(local_dir):
                print(f"Dataset {lang_code} {split} is missing in {local_dir}")
                missing_dirs += 1
            else:
                parquets_in_dir = glob.glob(os.path.join(local_dir, "*.parquet"))

                dir_linecount = 0

                for parquet_file in parquets_in_dir:
                    jsonlines_file = parquet_file.removesuffix(".parquet") + ".jsonl.zst"
                    if not os.path.exists(jsonlines_file):
                        print(f"Missing jsonlines file for {parquet_file}")
                        missing_jsonlines += 1
                        continue

                    linecount_file = f"{jsonlines_file}.linecount"
                    if not os.path.exists(linecount_file):
                        print(f"Missing linecount file for {jsonlines_file}")
                        missing_linecount += 1
                        continue

                    with open(linecount_file) as f:
                        dir_linecount += int(f.read())

                if dir_linecount != lines_expected:
                    print(f"Size mismatch for {lang_code} {split}: expected {lines_expected} lines, got {dir_linecount}")
                    size_mismatches += 1
                else:
                    print(f"Dataset {lang_code} {split} is correct.")
                    correct_files += 1

    print("=" * 60)
    print("Summary:")
    print(f"{correct_files} files are correct.")
    print(f"{missing_dirs} dirs (languages) are missing.")
    print(f"{missing_jsonlines} jsonl files are missing.")
    print(f"{missing_linecount} linecount files are missing.")
    print(f"{size_mismatches} files have size mismatches.")



if __name__ == "__main__":
    parser = argparse.ArgumentParser("Check FineWeb 2.1.0 jsonl file lengths")
    parser.add_argument("--output-dir", required=True, help="Output directory for converted data")
    parser.add_argument("--language-distribution", required=True, help="Path to fineweb2-language-distribution.csv")

    args = parser.parse_args()
    main(args.output_dir, args.language_distribution)
