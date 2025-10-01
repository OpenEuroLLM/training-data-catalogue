#!/bin/bash

#SBATCH --job-name=finepdfs-1.0-convert
#SBATCH --account=project_462000827
#SBATCH --partition=small
#SBATCH --time=24:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=4
#SBATCH --cpus-per-task=16
#SBATCH --mem=512G
#SBATCH --output=logs/%x-%j.log
#SBATCH --array=1

set -euo pipefail

module load LUMI
module load parallel

LANG=`sed -n "${SLURM_ARRAY_TASK_ID}p" languages`
echo "Working on ${LANG}"

PARQUET_DIR=/scratch/project_462000827/jhelcl/training-data-catalogue/finepdfs/1.0/tmp-repo/data/${LANG}

CATALOGUE_DIR=/scratch/project_462000953/training/catalogue
OUTPUT_DIR=$CATALOGUE_DIR/finepdfs/1.0.0/data/${LANG}

mkdir -p $OUTPUT_DIR

source /projappl/project_462000953/jhelcl/training-data-catalogue/env/bin/activate

# Load parquet files into array
mapfile -t parquet_files < <(find $PARQUET_DIR -name "*.parquet" -type f)
echo "$(date): Found ${#parquet_files[@]} parquet files"


for parquet_file in "${parquet_files[@]}"; do
    output_file="${parquet_file%.parquet}.jsonl.zst"
    output_file="${OUTPUT_DIR}/${output_file##*/}"

    if [ -e "$output_file" ]; then
        echo "output file $output_file already exists, skipping."
        continue
    fi

    echo "$(date): Starting conversion of $parquet_file"

    srun --ntasks=1 --mem=128G \
         python convert_single_parquet_to_jsonl.py \
             --infile "$parquet_file" \
             --outfile "$output_file" \
             --threads $SLURM_CPUS_PER_TASK \
             --chunk-size 2000 &
done

echo "$(date): All jobs started, waiting for completion..."
wait
echo "$(date): All conversions completed"
