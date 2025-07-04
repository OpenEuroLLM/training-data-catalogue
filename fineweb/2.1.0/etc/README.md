### FineWeb 2.1.0 Download and Conversion Pipeline


Steps:

1. Make sure to get the `fineweb2-language-distribution.csv` table from the [FineWeb 2 repository](https://github.com/huggingface/fineweb-2).
2. Download files in the Parquet format using `download.slurm` which calls `parquet_download.py`
3. To verify the downloaded files against `fineweb2-language-distribution.csv`, use `check_parquet_download.py` (this only checks file sizes, can be run on any node)
4. Parquet to JSON conversion is done in the `convert_single_parquet_to_json.py` and it is called from one of the `convert*.slurm` scripts
   (they differ in how SLURM is called on LUMI)
5. To verify the conversion, calculate number of lines per file using `count_lines.slurm` and then run `check_jsonl.py` (also a quick check, can be run on any node).