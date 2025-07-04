### FineWeb 2.1.0 Download and Conversion Pipeline


Steps:

1. Download files in the Parquet format using `download.slurm` which calls `parquet_download.py`
2. To verify the downloaded files against `fineweb2-language-distribution.csv`, use `check_parquet_download.py` (this only checks file sizes, can be run on any node)
3. Parquet to JSON conversion is done in the `convert_single_parquet_to_json.py` and it is called from one of the `convert*.slurm` scripts
   (they differ in how SLURM is called on LUMI)
4. To verify the conversion, calculate number of lines per file using `count_lines.slurm` and then run `check_jsonl.py` (also a quick check, can be run on any node).