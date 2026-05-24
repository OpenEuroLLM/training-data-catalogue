#!/bin/bash
#SBATCH --job-name=convert
#SBATCH --account=project_462001087
#SBATCH --partition=small
#SBATCH --time=24:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=4
#SBATCH --cpus-per-task=16
#SBATCH --mem=512G
#SBATCH --output=logs/%x-%A-%a.out

set -euo pipefail

module --quiet purge
module load LUMI
module load parallel

source /projappl/project_462000953/jhelcl/training-data-catalogue/env/bin/activate

CATALOGUE_DIR=/scratch/project_462000953/training/catalogue
LOCAL_CATALOGUE_DIR=/scratch/project_462000953/.tmp-ingest

array_offset=0
input_prefix="data"
dataset_name=""
revision=""
output_revision=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --array-offset)
            array_offset=$2
            shift 2
            ;;
        --input-prefix)
            input_prefix=$2
            shift 2
            ;;
        --output-revision)
            output_revision=$2
            shift 2
            ;;
        *)
            if [ -z "$dataset_name" ]; then
                dataset_name=$1
            elif [ -z "$revision" ]; then
                revision=$1
            fi
            shift
            ;;
    esac
done

if [ -z "$output_revision" ]; then
    output_revision=$revision
fi

if [ -z "$dataset_name" ] || [ -z "$revision" ]; then
    echo "Usage: sbatch --array=<range> convert.slurm [--array-offset N] [--input-prefix PATH] [--output-revision REV] <dataset_name> <revision>"
    echo "Example: sbatch --array=1-360 convert.slurm the-stack 1.2"
    echo "Example: sbatch --array=1-200 convert.slurm --array-offset 1000 fineweb 1.4.0"
    echo "Example: sbatch --array=1-7 convert.slurm --input-prefix "" german-commons d54ba51"
    exit 1
fi

if [ -n "$input_prefix" ]; then
    parquet_base=$LOCAL_CATALOGUE_DIR/$dataset_name/$revision/tmp-repo/$input_prefix
else
    parquet_base=$LOCAL_CATALOGUE_DIR/$dataset_name/$revision/tmp-repo
fi
splits_file="tmp.splits-${dataset_name}-${revision}"

# List subdirectories, store to file
if [ ! -f "$splits_file" ]; then
    find "$parquet_base" -maxdepth 1 -mindepth 1 -type d -printf '%f\n' | sort > "$splits_file"
fi

if [ ! -s "$splits_file" ]; then
    echo "Error: no subdirectories found in $parquet_base."
    echo "For flat parquet datasets (files directly in data/), re-run with --input-prefix \"\" to treat data/ as the single split."
    exit 1
fi

total_splits=$(wc -l < "$splits_file")

if [ -z "${SLURM_ARRAY_TASK_ID:-}" ]; then
    echo "Error: SLURM_ARRAY_TASK_ID is not set."
    echo "This script must be run as a SLURM array job."
    echo "Found $total_splits splits in $splits_file"
    echo "Usage: sbatch --array=1-$total_splits convert.slurm $dataset_name $revision"
    if [ $total_splits -gt 1000 ]; then
        echo "Note: The maximum array job index is 1000. For splits beyond that, use --array-offset:"
        echo "  sbatch --array=1-1000 convert.slurm $dataset_name $revision  # for the first 1000 splits"
        echo "  sbatch --array=1-150 convert.slurm --array-offset 1000 $dataset_name $revision  # for splits 1001 - 1150 (example)"
    fi
    exit 1
fi

offset=$((SLURM_ARRAY_TASK_ID + array_offset))

split=`sed -n "${offset}p" "$splits_file"`
echo "Working on ${split}"

parquet_dir=$parquet_base/${split}

# Output always goes to 'data/', but avoid 'data/data/' or '//'
if [ "$input_prefix" = "data" ] || [ -z "$input_prefix" ]; then
    if [ -z "$input_prefix" ] && [ "$split" = "data" ]; then
        output_dir=$CATALOGUE_DIR/$dataset_name/$output_revision/data
    else
        output_dir=$CATALOGUE_DIR/$dataset_name/$output_revision/data/${split}
    fi
else
    output_dir=$CATALOGUE_DIR/$dataset_name/$output_revision/data/$input_prefix/${split}
fi

mkdir -p $output_dir

# Load parquet files into array
mapfile -t parquet_files < <(find $parquet_dir -name "*.parquet" -type f)
echo "$(date): Found ${#parquet_files[@]} parquet files"


for parquet_file in "${parquet_files[@]}"; do
    relative_path="${parquet_file#$parquet_dir/}"  # such as train/000_00000.parquet
    relative_dir=$(dirname "$relative_path")       # train or test

    output_subdir="${output_dir}/${relative_dir}"
    mkdir -p "$output_subdir"

    output_file="${parquet_file%.parquet}.jsonl.zst"
    output_file="${output_subdir}/${output_file##*/}"

    if [ -e "$output_file" ]; then
        echo "output file $output_file already exists, skipping."
        continue
    fi

    echo "$(date): Starting conversion of $parquet_file"

    srun --ntasks=1 --mem=128G --cpu-bind=none \
         python convert_single_parquet_to_jsonl.py \
             --infile "$parquet_file" \
             --outfile "$output_file" \
             --threads $SLURM_CPUS_PER_TASK \
             --compression-level 10 \
             --chunk-size 2000 &
done

echo "$(date): All jobs started, waiting for completion..."
wait
echo "$(date): All conversions completed"
