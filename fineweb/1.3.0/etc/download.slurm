#!/bin/bash
#SBATCH --partition=cpu-troja
#SBATCH --time=18:00:00
#SBATCH --ntasks=128
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=16G
#SBATCH -o mainlog_download.log
#--SBATCH --account=...

set -exuo pipefail

CATALOGUE_DIR=/lnet/troja/projects/hplt/training-data-catalogue
OUTPUT_DIR=$CATALOGUE_DIR/fineweb/1.3.0/data
CRAWL_LIST=crawl_list.txt

mkdir -p $OUTPUT_DIR


if [ ! -e "$CRAWL_LIST" ] ; then
  python get_fineweb_names.py | grep sample > "$CRAWL_LIST"
fi

while read crawl_name ; do
  #echo sample-100BT | while read crawl_name; do
  srun --ntasks=1 --exclusive -o tasklog_${crawl_name}.log python fineweb_stream_single.py "$crawl_name" --output-dir $OUTPUT_DIR &
done < "$CRAWL_LIST"

wait
