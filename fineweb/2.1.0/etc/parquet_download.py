#!/usr/bin/env python3

import argparse
import csv
import os
import glob

from huggingface_hub import snapshot_download


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


def download_dataset(language, split, local_dir, max_workers):
    snapshot_download(
        "HuggingFaceFW/fineweb-2",
        repo_type="dataset",
        revision="v2.1.0",
        local_dir=local_dir,
        allow_patterns=[f"data/{language}/{split}/*"],
        max_workers=max_workers,
    )


def downloaded_size(local_dir):
    downloaded_bytes = 0
    for parquet_file in glob.glob(os.path.join(local_dir, "*.parquet")):
        downloaded_bytes += os.path.getsize(parquet_file)
    return downloaded_bytes


def main(output_dir, language_distribution, max_workers):
    metadata = load_language_metadata(language_distribution)

    successful_downloads = 0
    failed_downloads = 0
    already_downloaded = 0

    for split in ["test"]:
        for lang_code in metadata[split]:
            local_dir = os.path.join(output_dir, "data", lang_code, split)
            expected_size = metadata[split][lang_code]


            if not os.path.exists(local_dir):
                print(f"Dataset {lang_code} {split} not found in {local_dir} -- downloading")
                should_download = True

            else:
                downloaded_bytes = downloaded_size(local_dir)
                if downloaded_bytes != expected_size:  ## disable size check because the data is probably wrong
                    print(f"Dataset {lang_code} {split} found in {local_dir}, but size mismatch (actual {downloaded_bytes} != expected {expected_size}) -- downloading")
                    should_download = True

                else:
                    print(f"Dataset {lang_code} {split} already downloaded.")
                    already_downloaded += 1
                    should_download = False

            if should_download:
                download_dataset(lang_code, split, output_dir, max_workers)

                # check downloaded size
                downloaded_bytes = downloaded_size(local_dir)

                if downloaded_bytes != expected_size:
                    print(f"Mismatch for {lang_code} {split}: expected {expected_size}, got {downloaded_bytes}")
                    failed_downloads += 1
                else:
                    print(f"Successfully downloaded {lang_code} {split} with size {downloaded_bytes} bytes")
                    successful_downloads += 1


    print("=" * 60)
    print(f"Job finished, summary:")
    print(f"{successful_downloads} successful")
    print(f"{failed_downloads} failed")
    print(f"{already_downloaded} already downloaded")


if __name__ == "__main__":
    parser = argparse.ArgumentParser("Download FineWeb 2.0.1 dataset with intelligent file-by-file downloading")
    parser.add_argument("--output-dir", required=True, help="Output directory for downloaded data (a data/ subdir will be created)")
    parser.add_argument("--language-distribution", required=True, help="Path to fineweb2-language-distribution.csv")

    parser.add_argument("--max-workers", type=int, default=64,
        help="Maximum number of workers in snapshot_download (default: 64)")

    args = parser.parse_args()
    main(args.output_dir, args.language_distribution, args.max_workers)
