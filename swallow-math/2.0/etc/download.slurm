#!/bin/bash

#SBATCH --job-name=download-swallow-math
#SBATCH --account=project_462001087
#SBATCH --partition=small
#SBATCH --time=24:00:00
#SBATCH --cpus-per-task=32
#SBATCH --mem=256G
#SBATCH --output=logs/%x-%j.log

set -euo pipefail

module --quiet purge
module load LUMI

OUTPUT_DIR=/scratch/project_462000953/.tmp-ingest/swallow-math-v2/main/tmp-repo

mkdir -p $OUTPUT_DIR

hf auth login

hf download tokyotech-llm/swallow-math-v2 \
    --local-dir $OUTPUT_DIR \
    --revision main \
    --repo-type dataset \
    --include "stage3-qa/**" \
    --include "stage3-textbook/**"

echo "Download complete!"
