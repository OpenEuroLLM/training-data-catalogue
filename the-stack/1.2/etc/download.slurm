#!/bin/bash

#SBATCH --job-name=download
#SBATCH --account=project_462000827
#SBATCH --partition=small
#SBATCH --time=24:00:00
#SBATCH --cpus-per-task=32
#SBATCH --mem=256G
#SBATCH --output=logs/%x-%j.log

set -euo pipefail

module load LUMI

LOCAL_CATALOGUE_DIR=/scratch/project_462000827/jhelcl/training-data-catalogue
OUTPUT_DIR=$LOCAL_CATALOGUE_DIR/the-stack/1.2
REPO_DIR=$OUTPUT_DIR/tmp-repo

mkdir -p $OUTPUT_DIR

export HF_TOKEN_PATH=~/.cache/hf_hub_token
hf auth login

#git lfs install
#git config --global lfs.concurrenttransfers 32

echo "Starting download..."
#git clone --depth 1 --branch v1.2 https://huggingface.co/datasets/bigcode/the-stack $REPO_DIR
hf download bigcode/the-stack --local-dir $REPO_DIR --revision v1.2 --repo-type dataset

echo "Verifying git lfs download with fsck..."
git -C $REPO_DIR lfs fsck

echo "Download and verification complete!"
