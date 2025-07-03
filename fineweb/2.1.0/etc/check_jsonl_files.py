#!/usr/bin/env python3

import argparse
import csv
import os
import glob
import io
from concurrent.futures import ThreadPoolExecutor, as_completed
import zstandard as zstd

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


def count_zstd_lines(path):

    lines = 0
    with open(path, "rb") as f:
        cctx = zstd.ZstdDecompressor()
        with cctx.stream_reader(f) as decompressor:
            text_stream = io.TextIOWrapper(decompressor, encoding="utf-8")
            for line in text_stream:
                lines += 1

    return lines



def lines_in_dir(local_dir, num_threads):

    files_in_dir = glob.glob(os.path.join(local_dir, "*.jsonl.zst"))
    with ThreadPoolExecutor(max_workers=num_threads) as executor:
        future_to_path = {executor.submit(count_zstd_lines, path): path for path in files_in_dir}

    lines = 0
    for future in as_completed(future_to_path):
        path = future_to_path[future]
        try:
            lines += future.result()
        except Exception as exc:
            print(f"{path} produced exception {exc}")
            raise exc

    return lines


def check_downloads(output_dir, language_distribution, num_threads):
    metadata = load_language_metadata(language_distribution)

    missing_files = 0
    size_mismatches = 0
    correct_files = 0

    for split in metadata:
        for lang_code, lines_expected in metadata[split].items():
            if lang_code.endswith("_removed"):
                continue

            local_dir = os.path.join(output_dir, "data", lang_code, split)

            if not os.path.exists(local_dir):
                print(f"Dataset {lang_code} {split} is missing in {local_dir}")
                missing_files += 1
            else:
                lines_done = lines_in_dir(local_dir, num_threads=num_threads)
                if lines_done != lines_expected:
                    print(f"Size mismatch for {lang_code} {split}: expected {lines_expected} lines, got {lines_done}")
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
    parser = argparse.ArgumentParser("Check FineWeb 2.1.0 jsonl file lengths")
    parser.add_argument("--output-dir", required=True, help="Output directory for converted data")
    parser.add_argument("--language-distribution", required=True, help="Path to fineweb2-language-distribution.csv")
    parser.add_argument("--num-threads", required=False, default=1, type=int)

    args = parser.parse_args()
    check_downloads(args.output_dir, args.language_distribution, args.num_threads)
