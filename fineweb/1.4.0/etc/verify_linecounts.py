#!/usr/bin/env python3
import json
import os


fw_json = "fineweb-1.4.0-counts.json"
fw_catalogue_data_dir = "/scratch/project_462000953/training/catalogue/fineweb/1.4.0/data"


def get_linecount(dataset, chunk):
    chunk_linecount = chunk.removesuffix(".parquet") + ".jsonl.zst.linecount"
    path = os.path.join(fw_catalogue_data_dir, dataset, chunk_linecount)

    if not os.path.exists(path):
        print(f"skipping {dataset} {chunk} -- no linecount found")
        return 0

    with open(path) as fh:
        return int(fh.readline())


def main():
    with open(fw_json) as fh:
        metadata = json.load(fh)

    for dataset in metadata:
        if "sample" in dataset or dataset == "default" or dataset == "grand_total":
            continue

        total_real = 0

        for chunk in metadata[dataset]["files"]:
            expected_size = int(metadata[dataset]["files"][chunk])
            real_size = get_linecount(dataset, chunk)
            total_real += real_size

            if expected_size != real_size:
                print(f"{dataset} {chunk}: expected {expected_size}, got {real_size}")

        total_expected = int(metadata[dataset]["total"])

        if total_expected != total_real:
            print(f"[DATASET] {dataset}: expected {total_expected}, got {total_real}")
        else:
            print(f"[DATASET] {dataset} OK")

if __name__ == "__main__":
    main()
