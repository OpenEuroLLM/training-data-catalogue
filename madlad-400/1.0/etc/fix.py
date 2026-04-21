#!/usr/bin/env python3
"""
Fix text artifacts in MADLAD data.

Replaces in the text field:
  \\n -> actual newline
  \\t -> actual tab
  \\_ -> single backslash
"""

import argparse
import glob
import gzip
import io
import json
import os
import sys

import ftfy
import zstandard as zstd


def fix_text(text):
    text = text.replace('\\n', '\n')
    text = text.replace('\\t', '\t')
    text = text.replace('\\_', '\\')
    text = ftfy.fix_text(text, fix_character_width=False, uncurl_quotes=False)
    return text


def fix_file(input_path, output_path, threads=1):
    compressor = zstd.ZstdCompressor(level=10, threads=threads)
    with gzip.open(input_path, 'rt', encoding='utf-8') as fin, \
         open(output_path, 'wb') as fout_raw:
        with compressor.stream_writer(fout_raw) as fout_compressed:
            fout = io.TextIOWrapper(fout_compressed, encoding='utf-8')
            for i, line in enumerate(fin):
                line = line.rstrip('\n')
                if not line:
                    raise ValueError(f"empty line at position {i} in {input_path}")
                data = json.loads(line)
                data['text'] = fix_text(data['text'])
                print(json.dumps(data, ensure_ascii=False), file=fout)
            fout.flush()


def main():
    parser = argparse.ArgumentParser(description='Fix MADLAD text artifacts')
    parser.add_argument('--input-dir', required=True, help='Directory with .jsonl.gz input files')
    parser.add_argument('--output-dir', required=True, help='Directory to write .jsonl.zst output files')
    parser.add_argument('--threads', type=int, default=1, help='Threads for zstd compression')
    args = parser.parse_args()

    files = sorted(glob.glob(os.path.join(args.input_dir, '*.jsonl.gz')))
    if not files:
        raise FileNotFoundError(f"no .jsonl.gz files found in {args.input_dir}")

    os.makedirs(args.output_dir, exist_ok=True)

    for input_file in files:
        basename = os.path.basename(input_file)
        output_file = os.path.join(args.output_dir, basename.replace('.jsonl.gz', '.jsonl.zst'))
        if os.path.exists(output_file):
            print(f"fix_madlad.py: skipping {input_file} (output exists).")
            continue
        print(f"fix_madlad.py: processing {input_file}.", flush=True)
        fix_file(input_file, output_file, threads=args.threads)


if __name__ == '__main__':
    main()
