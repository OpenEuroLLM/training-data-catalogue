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

LOCAL_CATALOGUE_DIR=/scratch/project_462000827/jhelcl/training-data-catalogue
OUTPUT_DIR=$LOCAL_CATALOGUE_DIR/dclm/1.0
REPO_DIR=$OUTPUT_DIR/tmp-repo

git lfs install
git config --global lfs.concurrenttransfers 32

cd $REPO_DIR
git restore --source=HEAD :/
git -C $REPO_DIR lfs fsck
