#!/bin/bash

#SBATCH --job-name=fineweb-2.1.0-convert
#SBATCH --account=project_462000764
#SBATCH --partition=small
#SBATCH --time=24:00:00
#SBATCH --nodes=4
#SBATCH --ntasks=128
#SBATCH --cpus-per-task=4
#SBATCH --mem=512G

set -euo pipefail

module load LUMI
module load parallel

CATALOGUE_DIR=/scratch/project_462000953/training/catalogue
INPUT_DIR=$CATALOGUE_DIR/fineweb/2.1.0/data/

source /projappl/project_462000953/jhelcl/training-data-catalogue/env/bin/activate

# Load parquet files into array
mapfile -t parquet_files < <(find $INPUT_DIR -name "*.parquet" -type f)
echo "$(date): Found ${#parquet_files[@]} parquet files"


for parquet_file in "${parquet_files[@]}"; do
    output_file="${parquet_file%.parquet}.jsonl.zst"

    if [ -e "$output_file" ]; then
        echo "output file $output_file already exists, skipping."
        continue
    fi

    echo "$(date): Starting conversion of $parquet_file"

    srun --ntasks=1 \
         python convert_single_parquet_to_jsonl-para.py \
             --infile "$parquet_file" \
             --outfile "$output_file" \
             --threads $SLURM_CPUS_PER_TASK \
             --chunk-size 5000 &
done

echo "$(date): All jobs started, waiting for completion..."
wait
echo "$(date): All conversions completed"
