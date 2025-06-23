#!/bin/bash

#SBATCH --job-name=fineweb-1.3.0-download
#SBATCH --partition=small
#SBATCH --account=project_462000953
#SBATCH --time=72:00:00
#__SBATCH --nodes=4
#SBATCH --ntasks=108
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=16G

set -exuo pipefail

CATALOGUE_DIR=/scratch/project_462000953/training/catalogue
OUTPUT_DIR=$CATALOGUE_DIR/fineweb/1.3.0/data
CRAWL_LIST=crawl_list.txt

source /scratch/project_462000953/jhelcl/training-data-catalogue/env/bin/activate

mkdir -p $OUTPUT_DIR

if [ ! -e "$CRAWL_LIST" ] ; then
  python get_fineweb_names.py | grep -v "default\|sample" > "$CRAWL_LIST"
fi

while read crawl_name ; do
    echo  $crawl_name
    sleep 1
    srun --ntasks=1 -o tasklog_${crawl_name}.log python fineweb_stream_single.py "$crawl_name" --output-dir $OUTPUT_DIR &
done < "$CRAWL_LIST"

wait
