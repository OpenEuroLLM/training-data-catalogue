#!/bin/bash

#SBATCH --job-name=huggingface-download
#SBATCH --account=project_462000827
#SBATCH --partition=small
#SBATCH --time=72:00:00
#SBATCH --cpus-per-task=32
#SBATCH --mem=256G
#SBATCH --output=logs/%x-%j.log

set -euo pipefail

module load LUMI

DATASET_URL="https://huggingface.co/datasets/mlfoundations/dclm-baseline-1.0"

LOCAL_CATALOGUE_DIR=/scratch/project_462000827/jhelcl/training-data-catalogue
OUTPUT_DIR=$LOCAL_CATALOGUE_DIR/dclm/1.0
REPO_DIR=$OUTPUT_DIR/tmp-repo

mkdir -p $OUTPUT_DIR

git lfs install
git config --global lfs.concurrenttransfers 32

echo "Starting download..."
git clone $DATASET_URL $REPO_DIR

echo "Verifying git lfs download with fsck..."
git -C $REPO_DIR lfs fsck

echo "Download and verification complete!"
