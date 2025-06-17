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
OUTPUT_DIR=$CATALOGUE_DIR/fineweb/2.0.1/data
LANG_LIST=language_list.txt

mkdir -p $OUTPUT_DIR


if [ ! -e "$LANG_LIST" ] ; then
  python get_fineweb2_names.py | grep "_Guru" > "$LANG_LIST"
fi

while read language ; do
  srun --ntasks=1 --exclusive -o tasklog_${language}.log python fineweb2_stream_single.py $language --output-dir $OUTPUT_DIR &
done < "$LANG_LIST"

wait
