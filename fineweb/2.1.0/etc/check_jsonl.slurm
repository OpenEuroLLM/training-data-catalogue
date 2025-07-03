#!/bin/bash

#SBATCH --job-name=check-conversion
#SBATCH --account=project_462000764
#SBATCH --partition=small
#SBATCH --time=24:00:00
#SBATCH --nodes=1
#SBATCH --cpus-per-task=64
#SBATCH --mem=512G

set -euo pipefail

module load LUMI

CATALOGUE_DIR=/scratch/project_462000953/training/catalogue
DATA_DIR=$CATALOGUE_DIR/fineweb/2.1.0/

source /projappl/project_462000953/jhelcl/training-data-catalogue/env/bin/activate

python check_jsonl_files.py \
         --output-dir=$DATA_DIR \
         --language-distribution=fineweb2-language-distribution.csv \
	 --language=arb_Arab \
	 --num-threads=64
