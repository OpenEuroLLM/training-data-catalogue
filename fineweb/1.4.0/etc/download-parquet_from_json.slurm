#!/bin/bash

#SBATCH --job-name=fineweb-1.4.0-download
#SBATCH --account=project_462000827
#SBATCH --partition=small
#SBATCH --time=72:00:00
#SBATCH --cpus-per-task=120
#SBATCH --mem=256G

set -euo pipefail

module load LUMI

CATALOGUE_DIR=/scratch/project_462000953/training/catalogue
OUTPUT_DIR=/scratch/project_462000827/jhelcl/fineweb-1.4.0
METADATA_JSON=fineweb-1.4.0-counts.json

source /projappl/project_462000953/jhelcl/training-data-catalogue/env/bin/activate  # TODO move this to the official dir?
export HF_HUB_ENABLE_HF_TRASNSFER=1

mkdir -p $OUTPUT_DIR

python parquet_download_from_json.py \
       --output-dir $OUTPUT_DIR \
       --counts-json $METADATA_JSON \
       --max-workers 120 \
       --num-attempts 10 \
       --sleep-interval 30
