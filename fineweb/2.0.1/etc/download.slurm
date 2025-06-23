#!/bin/bash

#SBATCH --job-name=fineweb-2.0.1-download
#SBATCH --account=project_462000764
#SBATCH --partition=small
#SBATCH --time=72:00:00
#SBATCH --cpus-per-task=120
#SBATCH --mem=256G
#unused SBATCH --mem-per-cpu=16G
#unused SBATCH --array=1-3943%32


set -exuo pipefail

CATALOGUE_DIR=/scratch/project_462000953/training/catalogue
OUTPUT_DIR=$CATALOGUE_DIR/fineweb/2.0.1
LANG_LIST=language_list.txt

source /scratch/project_462000953/jhelcl/training-data-catalogue/env/bin/activate
export HF_HUB_ENABLE_HF_TRASNSFER=1

mkdir -p $OUTPUT_DIR

if [ ! -e "$LANG_LIST" ] ; then
    echo "$LANG_LIST does not exist. Create it first with get_fineweb2_names.py" 1>&2
    exit 1
fi

# crawl_name=`sed -n ${SLURM_ARRAY_TASK_ID}p $LANG_LIST`
# echo $crawl_name

# python single_lang_parquet_download.py "$crawl_name" --output-dir $OUTPUT_DIR
python full_parquet_download.py --output-dir $OUTPUT_DIR
