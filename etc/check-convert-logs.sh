#!/bin/bash

# this script greps out info/success logs from the parquet-jsonl
# conversion logs so only the interesting stuff remains

grep -v "Step created" logs/convert-*.log | \
grep -v "step creation still disabled" | \
grep -v "starting conversion" | \
grep -v "step creation temporarily disabled" | \
grep -v "Starting conversion" | \
grep -v "EEST: Found" | \
grep -v "All jobs started" | \
grep -v "craype-x86" | \
grep -v ".out:$" | \
grep -v "\.log:$" | \
grep -v "\.log:Working on" | \
grep -v "All conversions completed" | \
grep -v 'Found [0-9]\+ parquet files'
