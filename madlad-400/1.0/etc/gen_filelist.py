#!/usr/bin/env python3
"""Generate filelist.txt for parallel MADLAD fixing."""

import glob
import os

INPUT_DIR = '/scratch/project_462000953/training/catalogue/madlad-400/1.0/clean'
OUTPUT_DIR = '/scratch/project_462000953/training/catalogue/madlad-400/1.0/fixed'
N_JOBS = 200
FILELIST = os.path.join(os.path.dirname(__file__), 'filelist.txt')


def output_path(input_path):
    parts = input_path.split('/clean/', 1)
    return parts[0] + '/fixed/' + parts[1].replace('.jsonl.gz', '.jsonl.zst')


remaining = []
for input_file in sorted(glob.glob(os.path.join(INPUT_DIR, '*', '*.jsonl.gz'))):
    if not os.path.exists(output_path(input_file)):
        remaining.append(input_file)

total = len(remaining)
batch_size = (total + N_JOBS - 1) // N_JOBS
actual_jobs = (total + batch_size - 1) // batch_size

print(f"Total remaining: {total}")
print(f"Batch size: {batch_size}")
print(f"Array tasks: {actual_jobs}")
print(f"Writing {FILELIST}")

with open(FILELIST, 'w') as f:
    for i in range(actual_jobs):
        batch = remaining[i * batch_size:(i + 1) * batch_size]
        f.write(' '.join(batch) + '\n')
