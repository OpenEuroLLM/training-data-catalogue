#!/bin/bash

#SBATCH --job-name=fineweb-1.4.0-convert
#SBATCH --account=project_462000827
#SBATCH --partition=small
#SBATCH --time=24:00:00
#SBATCH --nodes=4
#SBATCH --ntasks=32
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=8G
#SBATCH --array=1-104

# the array argument is used as an index to the crawl_list and
# that particular crawl is then converted.

set -euo pipefail

module load LUMI

CATALOGUE_DIR=/scratch/project_462000953/training/catalogue
CRAWL_LIST=crawl_list.tsv
COMPRESSION_LEVEL=10

DATASET=`sed -n "${SLURM_ARRAY_TASK_ID}p" crawl_list.tsv | cut -f1`
INPUT_DIR=/scratch/project_462000827/jhelcl/fineweb-1.4.0/data/${DATASET}
OUTPUT_DIR=$CATALOGUE_DIR/fineweb/1.4.0/data/${DATASET}

echo "Working on ${DATASET}"
mkdir -p "${OUTPUT_DIR}"

source /projappl/project_462000953/jhelcl/training-data-catalogue/env/bin/activate

# Load parquet files into array
mapfile -t parquet_files < <(find $INPUT_DIR -name "*.parquet" -type f)
echo "$(date): Found ${#parquet_files[@]} parquet files"

for parquet_file in "${parquet_files[@]}"; do
    output_file="${parquet_file%.parquet}.jsonl.zst"
    output_file="${OUTPUT_DIR}/${output_file##*/}"

    if [ -e "$output_file" ]; then
        echo "output file $output_file already exists, skipping."
        continue
    fi

    echo "$(date): Starting conversion of $parquet_file"

    srun --ntasks=1 --nodes=1 --cpus-per-task=8 --mem-per-cpu=8G --exclusive \
         python convert_single_parquet_to_jsonl.py \
             --infile "$parquet_file" \
             --outfile "$output_file" \
             --threads $SLURM_CPUS_PER_TASK \
             --compression-level $COMPRESSION_LEVEL\
             --chunk-size 2000 &
done

echo "$(date): All jobs started, waiting for completion..."
wait
echo "$(date): All conversions completed"
