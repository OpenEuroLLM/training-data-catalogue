
#!/usr/bin/env python3

import argparse
import os
import glob
import time

from huggingface_hub import snapshot_download


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


def download_dataset(ccsplit, local_dir, max_workers):
    snapshot_download(
        "HuggingFaceFW/fineweb",
        repo_type="dataset",
        revision="v1.3.0",
        local_dir=local_dir,
        allow_patterns=[f"data/{ccsplit}/*"],
        max_workers=max_workers,
    )


def downloaded_size(local_dir):
    downloaded_bytes = 0
    for parquet_file in glob.glob(os.path.join(local_dir, "*.parquet")):
        downloaded_bytes += os.path.getsize(parquet_file)
    return round(downloaded_bytes / 1024 / 1024 / 1024, 1)


def main(output_dir, crawl_list_path, max_workers, num_attempts=5, sleep_interval=10, delta_gib=0.1):
    crawls = load_crawl_list(crawl_list_path)

    successful_downloads = 0
    failed_downloads = 0
    already_downloaded = 0

    for ccsplit in crawls:
        local_dir = os.path.join(output_dir, "data", ccsplit)
        expected_size = crawls[ccsplit]["gbsize"]

        if not os.path.exists(local_dir):
            print(f"Dataset {ccsplit} not found in {local_dir} -- downloading")
            should_download = True

        else:
            downloaded_gbytes = downloaded_size(local_dir)
            if (downloaded_gbytes - expected_size) > delta_gib:
                print(f"Dataset {ccsplit} found in {local_dir}, but size mismatch (actual {downloaded_gbytes}G != expected {expected_size}G) -- downloading")
                should_download = True

            else:
                print(f"Dataset {ccsplit} already downloaded.")
                already_downloaded += 1
                should_download = False

        if should_download:
            for attempt in range(num_attempts):
                failed = False

                try:
                    print(f"downloading {ccsplit}")
                    download_dataset(ccsplit, output_dir, max_workers)
                except KeyboardInterrupt:
                    raise
                except:
                    print("A non-keyboard-interrupt exception occurred during download -- trying to carry on")

                # check downloaded size
                downloaded_gbytes = downloaded_size(local_dir)

                if downloaded_gbytes == 0.0:
                    print("Downloaded zero bytes. Looks like HF hung up with error 429 but cannot be sure.")
                    failed = True

                elif (downloaded_gbytes - expected_size) > delta_gib:
                    print(f"Mismatch for {ccsplit}: expected {expected_size}G, got {downloaded_gbytes}G")
                    failed = True

                else:
                    print(f"Successfully downloaded {ccsplit} with size {downloaded_gbytes}G")
                    successful_downloads += 1
                    break

                if attempt < num_attempts - 1:
                    print(f"Re-trying in 10 seconds (attempt {attempt + 2} of {num_attempts})...")
                    time.sleep(sleep_interval)

            else:
                failed_downloads += 1

    print("=" * 60)
    print(f"Job finished, summary:")
    print(f"{successful_downloads} successful")
    print(f"{failed_downloads} failed")
    print(f"{already_downloaded} already downloaded")


if __name__ == "__main__":
    parser = argparse.ArgumentParser("Download FineWeb 1.3.0 dataset with intelligent file-by-file downloading")
    parser.add_argument("--output-dir", required=True, help="Output directory for downloaded data (a data/ subdir will be created)")
    parser.add_argument("--crawl-tsv", required=True, help="Path to a TSV file with a list of crawls to download and their expected sizes")

    parser.add_argument("--max-workers", type=int, default=64,
        help="Maximum number of workers in snapshot_download (default: 64)")
    parser.add_argument("--num-attempts", type=int, default=5,
        help="Number of attempts in case the download is corrupted or throws error")
    parser.add_argument("--sleep-interval", type=int, default=10,
        help="Interval in seconds setting amount of time between download attempts")

    args = parser.parse_args()
    main(args.output_dir, args.crawl_tsv, args.max_workers,
         args.num_attempts, args.sleep_interval)
