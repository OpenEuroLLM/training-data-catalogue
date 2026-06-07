#!/bin/bash

#SBATCH --job-name=convert
#SBATCH --account=project_462001087
#SBATCH --partition=small
#SBATCH --time=24:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem-per-cpu=1750
#SBATCH --output=logs/%x-%A-%a.out

set -euo pipefail

source /projappl/project_462000953/jhelcl/training-data-catalogue/env/bin/activate

CATALOGUE_DIR=/scratch/project_462000953/training/catalogue
LOCAL_CATALOGUE_DIR=/scratch/project_462000953/.tmp-ingest

dataset_name=""
revision=""
output_revision=""
input_prefix=""
INIT=false
MAX_TASKS=190

while [[ $# -gt 0 ]]; do
    case $1 in
        --init) INIT=true; shift ;;
        --input-prefix) input_prefix=$2; shift 2 ;;
        --output-revision) output_revision=$2; shift 2 ;;
        --max-tasks) MAX_TASKS=$2; shift 2 ;;
        *)
            if [ -z "$dataset_name" ]; then dataset_name=$1
            elif [ -z "$revision" ]; then revision=$1
            fi
            shift ;;
    esac
done

if [ -z "$output_revision" ]; then output_revision=$revision; fi

if [ -n "$input_prefix" ]; then
    parquet_base=$LOCAL_CATALOGUE_DIR/$dataset_name/$revision/tmp-repo/$input_prefix
else
    parquet_base=$LOCAL_CATALOGUE_DIR/$dataset_name/$revision/tmp-repo
fi

output_base=$CATALOGUE_DIR/$dataset_name/$output_revision/data
FILELIST="tmp.convert-${dataset_name}-${revision}.filelist"

mapfile -t all_files < <(find "$parquet_base" -name "*.parquet" -type f | sort)
total=${#all_files[@]}
n_tasks=$(( total < MAX_TASKS ? total : MAX_TASKS ))
batch=$(( (total + n_tasks - 1) / n_tasks ))

if $INIT; then
    printf '%s\n' "${all_files[@]}" > "$FILELIST"
    echo "Dataset:  $dataset_name/$revision -> $output_revision"
    echo "Source:   $parquet_base"
    echo "Output:   $output_base"
    echo "Files:    $total across $n_tasks tasks (~$batch files/task)"
    echo "Filelist: $FILELIST"
    echo ""
    echo "Submit:"
    echo "  sbatch --array=1-${n_tasks} --output='logs/%x-%A-%a.out' $0 --input-prefix '${input_prefix}' --output-revision ${output_revision} ${dataset_name} ${revision}"
    exit 0
fi

if [ -z "${SLURM_ARRAY_TASK_ID:-}" ]; then
    echo "Run with --init first to generate filelist and get the submit command." >&2
    exit 1
fi

start=$(( (SLURM_ARRAY_TASK_ID - 1) * batch ))
end=$(( start + batch ))
(( end > total )) && end=$total

echo "Task $SLURM_ARRAY_TASK_ID: files $((start + 1))-${end} of $total"

mapfile -t files < <(sed -n "$((start + 1)),${end}p" "$FILELIST")

for parquet_file in "${files[@]}"; do
    relative_path="${parquet_file#${parquet_base}/}"
    relative_dir=$(dirname "$relative_path")
    output_subdir="${output_base}/${relative_dir}"
    mkdir -p "$output_subdir"

    output_file="${output_subdir}/$(basename "${parquet_file%.parquet}.jsonl.zst")"

    if [ -e "$output_file" ]; then
        echo "skip: $(basename $output_file)"
        continue
    fi

    echo "$(date): converting $(basename $parquet_file)"
    python convert_single_parquet_to_jsonl.py \
        --infile "$parquet_file" \
        --outfile "$output_file" \
        --threads $SLURM_CPUS_PER_TASK \
        --compression-level 10 \
        --chunk-size 2000
done

echo "$(date): task $SLURM_ARRAY_TASK_ID done"
