#!/bin/bash

#SBATCH --job-name=counts
#SBATCH --account=project_462001087
#SBATCH --partition=small
#SBATCH --time=72:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=8G
#SBATCH --output=logs/%x-%j.out

set -euo pipefail

source /pfs/lustrep2/scratch/project_462000953/training/catalogue/local/bin/activate

TARGET=""
PATTERN='\.zst$'
MAX_TASKS=190
AGGREGATE=false
REPORT=false
INIT=false
KEY="text"

while [[ $# -gt 0 ]]; do
    case $1 in
        --pattern) PATTERN=$2; shift 2 ;;
        --max-tasks) MAX_TASKS=$2; shift 2 ;;
        --key) KEY=$2; shift 2 ;;
        --aggregate) AGGREGATE=true; shift ;;
        --report) REPORT=true; shift ;;
        --init) INIT=true; shift ;;
        *) TARGET=$1; shift ;;
    esac
done

if [ -z "$TARGET" ] || ( ! $AGGREGATE && ! $REPORT && ! $INIT && [ -z "${SLURM_ARRAY_TASK_ID:-}" ] ); then
    echo "Usage: $0 --init     [--pattern REGEX] <target_dir>" >&2
    echo "       $0 [--max-tasks N] [--pattern REGEX] <target_dir>  (as array task)" >&2
    echo "       $0 --aggregate                                  <target_dir>" >&2
    echo "       $0 --report   [--depth N]                       <target_dir>" >&2
    exit 1
fi

TARGET=$(realpath "$TARGET")
CATALOGUE_ROOT=/pfs/lustrep2/scratch/project_462000953/training/catalogue
FILELIST="tmp.counts-${TARGET#${CATALOGUE_ROOT}/}.filelist"
FILELIST="${FILELIST//\//-}"

if $REPORT; then
    python3 counts_runner.py report "$TARGET"
    exit 0
fi

if $AGGREGATE; then
    python3 counts_runner.py aggregate "$TARGET"
    exit 0
fi

if $INIT; then
    mapfile -t all_files < <(find "$TARGET" -type f | grep -E "$PATTERN" | sort)
    total=${#all_files[@]}
    printf '%s\n' "${all_files[@]}" > "$FILELIST"
    echo "Target:     $TARGET"
    echo "Pattern:    $PATTERN"
    echo "Files:      $total"
    echo "Filelist:   $FILELIST"
    echo ""
    echo "Submit:"
    echo "  mkdir -p logs"
    echo "  sbatch --array=1-190 --output='logs/%x-%A-%a.out' $0 --key '$KEY' $TARGET"
    echo "  # to use fewer tasks: change --array=1-N and add --max-tasks N to the counts.array.slurm arguments"
    echo "  # after the array finishes:"
    echo "  bash $0 --aggregate $TARGET"
    echo "  # after aggregate finishes:"
    echo "  bash $0 --report $TARGET"
    exit 0
fi

total=$(wc -l < "$FILELIST")
n_tasks=$(( total < MAX_TASKS ? total : MAX_TASKS ))
batch=$(( (total + n_tasks - 1) / n_tasks ))

start=$(( (SLURM_ARRAY_TASK_ID - 1) * batch ))
end=$(( start + batch ))
(( end > total )) && end=$total

echo "Task $SLURM_ARRAY_TASK_ID: files $((start + 1))-$end of $total"
python3 counts_runner.py count-files --key "$KEY" "$FILELIST" "$start" "$end"
