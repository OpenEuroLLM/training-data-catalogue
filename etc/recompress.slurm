#!/bin/bash
#SBATCH --job-name=recompress
#SBATCH --account=project_462000963
#SBATCH --partition=small
#SBATCH --time=24:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=4
#SBATCH --cpus-per-task=16
#SBATCH --mem=512G
#SBATCH --output=logs/%x-%j.log

set -euo pipefail

module --quiet purge
module load LUMI
module load parallel

source /projappl/project_462000953/jhelcl/training-data-catalogue/env/bin/activate

CATALOGUE_DIR=/scratch/project_462000953/training/catalogue
LOCAL_CATALOGUE_DIR=/scratch/project_462000827/jhelcl/training-data-catalogue

array_offset=0
input_prefix="data"
dataset_name=""
revision=""

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

if [ -z "$dataset_name" ] || [ -z "$revision" ]; then
    echo "Usage: sbatch --array=<range> recompress.slurm [--array-offset N] [--input-prefix PATH] <dataset_name> <revision>"
    echo "Example: sbatch --array=1-360 recompress.slurm the-stack 1.2"
    echo "Example: sbatch --array=1-200 recompress.slurm --array-offset 1000 fineweb 1.4.0"
    echo "Example: sbatch --array=1-7 recompress.slurm --input-prefix "" german-commons d54ba51"
    exit 1
fi

if [ -n "$input_prefix" ]; then
    input_base=$LOCAL_CATALOGUE_DIR/$dataset_name/$revision/tmp-repo/$input_prefix
else
    input_base=$LOCAL_CATALOGUE_DIR/$dataset_name/$revision/tmp-repo
fi
splits_file="tmp.splits-${dataset_name}-${revision}"

# List subdirectories, store to file
if [ ! -f "$splits_file" ]; then
    for dir in "$input_base"/*/ ; do
        basename "$dir"
    done | sort > "$splits_file"
fi

total_splits=$(wc -l < "$splits_file")

if [ -z "${SLURM_ARRAY_TASK_ID:-}" ]; then
    echo "Error: SLURM_ARRAY_TASK_ID is not set."
    echo "This script must be run as a SLURM array job."
    echo "Found $total_splits splits in $splits_file"
    echo "Usage: sbatch --array=1-$total_splits recompress.slurm $dataset_name $revision"
    if [ $total_splits -gt 1000 ]; then
        echo "Note: The maximum array job index is 1000. For splits beyond that, use --array-offset:"
        echo "  sbatch --array=1-1000 recompress.slurm $dataset_name $revision  # for the first 1000 splits"
        echo "  sbatch --array=1-150 recompress.slurm --array-offset 1000 $dataset_name $revision  # for splits 1001 - 1150 (example)"
    fi
    exit 1
fi

offset=$((SLURM_ARRAY_TASK_ID + array_offset))

split=`sed -n "${offset}p" "$splits_file"`
echo "Working on ${split}"

input_dir=$input_base/${split}

# Output always goes to 'data/', but avoid 'data/data/' or '//'
if [ "$input_prefix" = "data" ] || [ -z "$input_prefix" ]; then
    output_dir=$CATALOGUE_DIR/$dataset_name/$revision/data/${split}
else
    output_dir=$CATALOGUE_DIR/$dataset_name/$revision/data/$input_prefix/${split}
fi

mkdir -p $output_dir

# Load gz files into array
mapfile -t input_files < <(find $input_dir -name "*.gz" -type f)
echo "$(date): Found ${#input_files[@]} gz files"


for input_file in "${input_files[@]}"; do
    relative_path="${input_file#$input_dir/}"  # such as train/000_00000.jsonl.gz
    relative_dir=$(dirname "$relative_path")       # train or test

    output_subdir="${output_dir}/${relative_dir}"
    mkdir -p "$output_subdir"

    output_file="${input_file%.gz}.zst"
    output_file="${output_subdir}/${output_file##*/}"

    if [ -e "$output_file" ]; then
        echo "output file $output_file already exists, skipping."
        continue
    fi

    echo "$(date): Starting recompression of $input_file"

    srun --ntasks=1 --cpus-per-task=$SLURM_CPUS_PER_TASK --mem=128G \
         bash -c "zcat \"$input_file\" | zstd -10 -T$SLURM_CPUS_PER_TASK -o \"$output_file\"" &
done

echo "$(date): All jobs started, waiting for completion..."
wait
echo "$(date): All conversions completed"
