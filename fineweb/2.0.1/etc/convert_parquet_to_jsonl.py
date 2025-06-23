#!/usr/bin/env python3

import argparse
import pandas as pd

def main(infile, outfile):
    df = pd.read_parquet(args.infile)
    df.to_json(args.outfile, orient='records', lines=True)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Convert Parquet to JSONL')
    parser.add_argument('--infile', required=True, help='Path to input Parquet file')
    parser.add_argument('--outfile', required=True, help='Path to output JSONL file')
    args = parser.parse_args()

    main(args.infile, args.outfile)
