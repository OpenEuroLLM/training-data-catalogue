#!/bin/bash

#SBATCH --job-name=fix-madlad
#SBATCH --account=project_462001087
#SBATCH --partition=small
#SBATCH --time=72:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=1750
#SBATCH --output=logs/%x-%A-%a.out

set -euo pipefail

module --quiet purge
module load LUMI

source /projappl/project_462000953/jhelcl/training-data-catalogue/env/bin/activate

CATALOGUE_DIR=/scratch/project_462000953/training/catalogue
INPUT_DIR=$CATALOGUE_DIR/madlad-400/1.0/clean
OUTPUT_DIR=$CATALOGUE_DIR/madlad-400/1.0/fixed

mapfile -t langs < <(ls "$INPUT_DIR")

if [ -z "${SLURM_ARRAY_TASK_ID:-}" ]; then
    echo "Usage: sbatch --array=1-${#langs[@]} fix.slurm"
    echo "Found ${#langs[@]} language directories."
    exit 1
fi

lang="${langs[$((SLURM_ARRAY_TASK_ID - 1))]}"
echo "Processing language: $lang"

python fix.py \
    --input-dir "$INPUT_DIR/$lang" \
    --output-dir "$OUTPUT_DIR/$lang" \
    --threads "$SLURM_CPUS_PER_TASK"
