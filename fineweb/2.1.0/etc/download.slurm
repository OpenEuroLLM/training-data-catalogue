#!/bin/bash

#SBATCH --job-name=fineweb-2.1.0-download
#SBATCH --account=project_462000764
#SBATCH --partition=small
#SBATCH --time=72:00:00
#SBATCH --cpus-per-task=120
#SBATCH --mem=256G
#unused SBATCH --mem-per-cpu=16G
#unused SBATCH --array=1-3943%32

set -euo pipefail

module load LUMI
module load wget

CATALOGUE_DIR=/scratch/project_462000953/training/catalogue
OUTPUT_DIR=$CATALOGUE_DIR/fineweb/2.1.0
FW2_LANG_DISTRIBUTION=fineweb2-language-distribution.csv

source /projappl/project_462000953/jhelcl/training-data-catalogue/env/bin/activate  # TODO move this to the official dir?
export HF_HUB_ENABLE_HF_TRASNSFER=1

mkdir -p $OUTPUT_DIR

if [ ! -e "$FW2_LANG_DISTRIBUTION" ] ; then
    echo "Dowloading language distribution table with metadata"
    wget "https://raw.githubusercontent.com/huggingface/fineweb-2/refs/heads/main/fineweb2-language-distribution.csv"
fi

# crawl_name=`sed -n ${SLURM_ARRAY_TASK_ID}p $LANG_LIST`
# echo $crawl_name

# python single_lang_parquet_download.py "$crawl_name" --output-dir $OUTPUT_DIR
# python full_parquet_download.py --output-dir $OUTPUT_DIR

python parquet_download.py \
       --output-dir $OUTPUT_DIR \
       --language-distribution $FW2_LANG_DISTRIBUTION \
       --max-workers 120 \
       --num-attempts 10 \
       --sleep-interval 30
