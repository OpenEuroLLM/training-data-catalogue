#!/bin/bash
#SBATCH --job-name=convert
#SBATCH --account=project_462000827
#SBATCH --partition=small
#SBATCH --time=24:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=4
#SBATCH --cpus-per-task=16
#SBATCH --mem=512G
#SBATCH --output=logs/%x-%j.log
#SBATCH --array=181-360
# total langs: 360

set -euo pipefail

module load LUMI
module load parallel

offset=$((SLURM_ARRAY_TASK_ID))
#offset=$((SLURM_ARRAY_TASK_ID+1000))

LANG=`sed -n "${offset}p" languages`
echo "Working on ${LANG}"

PARQUET_DIR=/scratch/project_462000827/jhelcl/training-data-catalogue/the-stack/1.2/tmp-repo/data/${LANG}

CATALOGUE_DIR=/scratch/project_462000953/training/catalogue
OUTPUT_DIR=$CATALOGUE_DIR/the-stack/1.2/data/${LANG}

mkdir -p $OUTPUT_DIR

source /projappl/project_462000953/jhelcl/training-data-catalogue/env/bin/activate

# Load parquet files into array
mapfile -t parquet_files < <(find $PARQUET_DIR -name "*.parquet" -type f)
echo "$(date): Found ${#parquet_files[@]} parquet files"


for parquet_file in "${parquet_files[@]}"; do
    relative_path="${parquet_file#$PARQUET_DIR/}"  # such as train/000_00000.parquet
    relative_dir=$(dirname "$relative_path")       # train or test

    output_subdir="${OUTPUT_DIR}/${relative_dir}"
    mkdir -p "$output_subdir"

    output_file="${parquet_file%.parquet}.jsonl.zst"
    output_file="${output_subdir}/${output_file##*/}"

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
