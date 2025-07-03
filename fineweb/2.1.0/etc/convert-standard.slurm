#!/bin/bash

#SBATCH --job-name=fineweb-2.1.0-convert
#SBATCH --account=project_462000827
#SBATCH --partition=standard
#SBATCH --time=4:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=32
#SBATCH --cpus-per-task=4
#SBATCH --mem=0

set -euo pipefail

module load LUMI
module load parallel

CATALOGUE_DIR=/scratch/project_462000953/training/catalogue
INPUT_DIR=$CATALOGUE_DIR/fineweb/2.1.0/data/arb_Arab
LANGUAGE_DISTRIBUTION=fineweb2-language-distribution.csv

source /projappl/project_462000953/jhelcl/training-data-catalogue/env/bin/activate

# Load parquet files into array
mapfile -t parquet_files < <(find $INPUT_DIR -name "*.parquet" -type f | grep -v _removed | sort)
echo "$(date): Found ${#parquet_files[@]} parquet files"


for parquet_file in "${parquet_files[@]}"; do
    output_file="${parquet_file%.parquet}.jsonl.zst"
    #like: /scratch/project_462000953/training/catalogue/fineweb/2.1.0/data/log_Latn/train/000_00000.jsonl.zst


    if [ -e "$output_file" ]; then
	# lines_done=`cat "$output_file" | wc -l`

	# noprefix=${output_file#"$INPUT_DIR"/}
	# lang=${noprefix%%/*}

	# nolang=${noprefix#*/}
	# fold=${nolang%%/*}

	# lines_expected=`grep "${lang},${fold}" "$LANGUAGE_DISTRIBUTION | cut -f8 --delim=','`

	# if [ "$lines_expected" = "$lines_done" ] ; then

	### careful files are not the same thing as languages

	echo "output file $output_file already exists, skipping."
	continue

    fi

    echo "$(date): Starting conversion of $parquet_file"

    srun --ntasks=1 \
         python convert_single_parquet_to_jsonl-para.py \
             --infile "$parquet_file" \
             --outfile "$output_file" \
             --threads $SLURM_CPUS_PER_TASK \
             --chunk-size 512 &
done

echo "$(date): All jobs started, waiting for completion..."
wait
echo "$(date): All conversions completed"
