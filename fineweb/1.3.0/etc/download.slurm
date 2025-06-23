#!/bin/bash

#SBATCH --job-name=fineweb-1.3.0-download
#SBATCH --partition=small
#SBATCH --account=project_462000764
#SBATCH --time=12:00:00
#SBATCH --array=1-104%2
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=16G

set -exuo pipefail

CATALOGUE_DIR=/scratch/project_462000953/training/catalogue
OUTPUT_DIR=$CATALOGUE_DIR/fineweb/1.3.0/data
CRAWL_LIST=crawl_list.txt

source /scratch/project_462000953/jhelcl/training-data-catalogue/env/bin/activate

mkdir -p $OUTPUT_DIR

# # We expect crawl list present and having 104 lines (for the array job)
# if [ ! -e "$CRAWL_LIST" ] ; then
#   python get_fineweb_names.py | grep -v "default\|sample" > "$CRAWL_LIST"
# fi

crawl_name=`sed -n ${SLURM_ARRAY_TASK_ID}p $CRAWL_LIST`
echo $crawl_name

python fineweb_stream_single.py "$crawl_name" --output-dir $OUTPUT_DIR
