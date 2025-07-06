#!/bin/bash

#SBATCH --job-name=line_counting
#SBATCH --account=project_462000764
#SBATCH --partition=small
#SBATCH --time=24:00:00
#SBATCH --nodes=1
#SBATCH --tasks=32
#SBATCH --cpus-per-task=4
#SBATCH --mem=512G

set -euo pipefail
shopt -s nullglob

module load LUMI

CATALOGUE_DIR=/scratch/project_462000953/training/catalogue
DATA_DIR=$CATALOGUE_DIR/fineweb/2.1.0

source /projappl/project_462000953/jhelcl/training-data-catalogue/env/bin/activate

for lang_dir in $DATA_DIR/data/???_????; do
    for split in train test; do
	for file in $lang_dir/$split/*.jsonl.zst; do
	    linecount_file=$file.linecount
	    if [ -e $linecount_file ]; then
		if [ $linecount_file -nt $file ]; then
		    echo "$linecount_file exists and is newer - skipping" >&2
		    continue
		fi
	    fi

	    echo "counting lines of $file" >&2
	    srun --exclusive --ntasks=1 --mem-per-cpu=4G \
		 zstdcat_and_count.sh $file $linecount_file &
	done
    done
done

wait
