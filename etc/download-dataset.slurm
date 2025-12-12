#!/bin/bash

#SBATCH --job-name=download
#SBATCH --account=project_462000827
#SBATCH --partition=small
#SBATCH --time=24:00:00
#SBATCH --cpus-per-task=32
#SBATCH --mem=256G
#SBATCH --output=logs/%x-%j.log

set -euo pipefail

export HF_TOKEN_PATH=~/.cache/hf_hub_token
LOCAL_CATALOGUE_DIR=/scratch/project_462000827/jhelcl/training-data-catalogue

GIT_USERNAME=jindrahelcl
GIT_PASSWORD=`cat $HF_TOKEN_PATH`

USE_GIT=false
DATASET=""
REVISION=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --use-git)
            USE_GIT=true
            shift
            ;;
        *)
            if [ -z "$DATASET" ]; then
                DATASET=$1
            elif [ -z "$REVISION" ]; then
                REVISION=$1
            fi
            shift
            ;;
    esac
done

if [ -z "$DATASET" ] || [ -z "$REVISION" ]; then
    echo "Usage: sbatch download-dataset.slurm [--use-git] <dataset> <revision>"
    echo "Example: sbatch download-dataset.slurm bigcode/the-stack v1.2"
    echo "Example: sbatch download-dataset.slurm --use-git bigcode/the-stack v1.2"
    exit 1
fi

module --quiet purge
module load LUMI

DATASET_NAME=$(basename $DATASET)
OUTPUT_DIR=$LOCAL_CATALOGUE_DIR/$DATASET_NAME/$REVISION
REPO_DIR=$OUTPUT_DIR/tmp-repo

mkdir -p $OUTPUT_DIR

echo "Starting download..."
echo "Dataset: $DATASET"
echo "Revision: $REVISION"
echo "Output directory: $OUTPUT_DIR"
echo "Method: $([ "$USE_GIT" = true ] && echo "git lfs" || echo "hf download")"

if [ "$USE_GIT" = true ]; then
    git lfs install
    git config --global lfs.concurrenttransfers 32

    git clone --no-checkout https://$GIT_USERNAME:$GIT_PASSWORD@huggingface.co/datasets/$DATASET $REPO_DIR
    git -C $REPO_DIR checkout $REVISION

    echo "Verifying git lfs download with fsck..."
    git -C $REPO_DIR lfs fsck
else
    hf auth login

    hf download $DATASET --local-dir $REPO_DIR --revision $REVISION --repo-type dataset
fi

echo "Download and verification complete!"
