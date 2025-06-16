#!/usr/bin/env python3

import argparse
import os
import jsonlines
from datasets import load_dataset


def main(crawl_name, dir_name, batch_size, limit):
    fw = load_dataset("HuggingFaceFW/fineweb", name=crawl_name, split="train", streaming=True)

    current_batch = [None] * batch_size
    current_batch_size = 0
    loaded = 0

    with jsonlines.open(os.path.join(dir_name, f"{crawl_name}.jsonl"), "w") as writer:

        for sample in fw:
            current_batch[current_batch_size] = sample
            current_batch_size += 1
            loaded += 1

            if loaded == limit:
                break

            if current_batch_size == batch_size:
                writer.write_all(current_batch)
                current_batch_size = 0

        if current_batch_size > 0:
            writer.write_all(current_batch[:current_batch_size])
            current_batch_size = 0


if __name__ == "__main__":
    parser = argparse.ArgumentParser("download single part of fineweb")
    parser.add_argument("name", help="Crawl name")
    parser.add_argument("--output-dir", help="Output directory", default=".")
    parser.add_argument("--batch-size", default=100000, type=int)
    parser.add_argument("--limit", default=0, type=int, required=False)
    args = parser.parse_args()

    if args.limit != 0:
        raise NotImplementedError("there is a bug in datasets/pyarrow that "
                                  "causes crashes when the dataset is not "
                                  "loaded completely")

    main(args.name, args.output_dir, args.batch_size, args.limit)
