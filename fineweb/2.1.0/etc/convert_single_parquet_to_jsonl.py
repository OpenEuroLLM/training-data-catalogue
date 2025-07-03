#!/usr/bin/env python3

import argparse
import pyarrow.parquet as pq
import jsonlines
import zstandard as zstd
from concurrent.futures import ThreadPoolExecutor
import threading
import io


def process_chunk(records_chunk):
    buffer = io.BytesIO()
    with jsonlines.Writer(buffer) as writer:
        for record in records_chunk:
            writer.write(record)
    return buffer.getvalue()


def main(infile, outfile, num_threads=4, chunk_size=10000):
    table = pq.read_table(infile)
    records = table.to_pylist()

    chunks = [records[i:i + chunk_size] for i in range(0, len(records), chunk_size)]

    with open(outfile, 'wb') as f:
        cctx = zstd.ZstdCompressor()
        with cctx.stream_writer(f) as compressor:
            with ThreadPoolExecutor(max_workers=num_threads) as executor:
                for chunk_data in executor.map(process_chunk, chunks):
                    compressor.write(chunk_data)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Convert Parquet to compressed JSONL')
    parser.add_argument('--infile', required=True, help='Path to input Parquet file')
    parser.add_argument('--outfile', required=True, help='Path to output compressed JSONL file')
    parser.add_argument('--threads', type=int, default=4, help='Number of threads for processing')
    parser.add_argument('--chunk-size', type=int, default=10000, help='Number of records per chunk')
    args = parser.parse_args()

    main(args.infile, args.outfile, args.threads, args.chunk_size)