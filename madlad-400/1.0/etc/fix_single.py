#!/usr/bin/env python3
"""Fix text artifacts in a single MADLAD file."""

import argparse
import gzip
import io
import json
import os

import ftfy
import zstandard as zstd


def fix_text(text):
    text = text.replace('\\n', '\n')
    text = text.replace('\\t', '\t')
    text = text.replace('\\_', '\\')
    text = ftfy.fix_text(text, fix_character_width=False, uncurl_quotes=False)
    return text


def main():
    parser = argparse.ArgumentParser(description='Fix MADLAD text artifacts in a single file')
    parser.add_argument('--input-file', required=True, help='Input .jsonl.gz file')
    parser.add_argument('--output-file', required=True, help='Output .jsonl.zst file')
    parser.add_argument('--threads', type=int, default=1, help='Threads for zstd compression')
    args = parser.parse_args()

    if os.path.exists(args.output_file):
        print(f"fix_single.py: skipping {args.input_file} (output exists).", flush=True)
        return

    print(f"fix_single.py: processing {args.input_file}.", flush=True)
    os.makedirs(os.path.dirname(args.output_file), exist_ok=True)
    compressor = zstd.ZstdCompressor(level=10, threads=args.threads)
    with gzip.open(args.input_file, 'rt', encoding='utf-8') as fin, \
         open(args.output_file, 'wb') as fout_raw:
        with compressor.stream_writer(fout_raw) as fout_compressed:
            fout = io.TextIOWrapper(fout_compressed, encoding='utf-8')
            for i, line in enumerate(fin):
                line = line.rstrip('\n')
                if not line:
                    raise ValueError(f"empty line at position {i} in {args.input_file}")
                data = json.loads(line)
                data['text'] = fix_text(data['text'])
                print(json.dumps(data, ensure_ascii=False), file=fout)
            fout.flush()


if __name__ == '__main__':
    main()
