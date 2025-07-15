#!/usr/bin/env python3

import argparse
import os
import glob
import time
import json

from huggingface_hub import snapshot_download


def load_metadata_json(path):
    with open(path) as fh:
        return json.load(fh)


def chunk_download(ccsplit, chunk, local_dir, max_workers):
    snapshot_download(
        "HuggingFaceFW/fineweb",
        repo_type="dataset",
        revision="v1.4.0",
        local_dir=local_dir,
        allow_patterns=[f"data/{ccsplit}/{chunk}"],
        max_workers=max_workers,
    )


def main(output_dir, json_path, max_workers, num_attempts=5, sleep_interval=10, delta_gib=100):
    metadata = load_metadata_json(json_path)

    successful_downloads = 0
    failed_downloads = 0
    already_downloaded = 0

    for ccsplit in metadata:
        if "sample" in ccsplit or ccsplit == "default" or ccsplit == "grand_total":
            continue

        for chunk in metadata[ccsplit]["files"]:
            target_path = os.path.join(output_dir, "data", ccsplit, chunk)

            if os.path.exists(target_path):
                already_downloaded += 1
                continue

            print(f"{ccsplit} {chunk}: parquet file not found -- downloading")

            for attempt in range(num_attempts):
                try:
                    chunk_download(ccsplit, chunk, output_dir, max_workers)
                except KeyboardInterrupt:
                    raise
                except:
                    print(f"{ccsplit} {chunk}: A non-keyboard-interrupt exception occurred during download -- trying to carry on")

                if not os.path.exists(target_path):
                    print(f"{ccsplit} {chunk}: error -- file not downloaded")

                downloaded_bytes = os.path.getsize(target_path)

                if downloaded_bytes == 0:
                    print(f"{ccsplit} {chunk}: error -- downloaded zero bytes (maybe error 429?)")

                else:
                    print(f"{ccsplit} {chunk}: download done with {downloaded_bytes}")
                    successful_downloads += 1
                    break

                if attempt < num_attempts - 1:
                    print(f"{ccsplit} {chunk}: re-trying in 10 seconds (attempt {attempt + 2} of {num_attempts})...")
                    time.sleep(sleep_interval)

            else:
                failed_downloads += 1

    print("=" * 60)
    print(f"Job finished, summary:")
    print(f"{successful_downloads} successful")
    print(f"{failed_downloads} failed")
    print(f"{already_downloaded} already downloaded")


if __name__ == "__main__":
    parser = argparse.ArgumentParser("Download FineWeb 1.4.0 dataset with intelligent file-by-file downloading")
    parser.add_argument("--output-dir", required=True, help="Output directory for downloaded data (a data/ subdir will be created)")
    parser.add_argument("--counts-json", required=True, help="A JSON file with line counts")

    parser.add_argument("--max-workers", type=int, default=64,
        help="Maximum number of workers in snapshot_download (default: 64)")
    parser.add_argument("--num-attempts", type=int, default=5,
        help="Number of attempts in case the download is corrupted or throws error")
    parser.add_argument("--sleep-interval", type=int, default=10,
        help="Interval in seconds setting amount of time between download attempts")

    args = parser.parse_args()
    main(args.output_dir, args.counts_json, args.max_workers,
         args.num_attempts, args.sleep_interval)
