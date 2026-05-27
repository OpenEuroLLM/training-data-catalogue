#!/bin/bash

#SBATCH --job-name=verify-gzip
#SBATCH --account=project_462001087
#SBATCH --partition=small
#SBATCH --time=4:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=1750
#SBATCH --output=logs/%x-%j.out

set -euo pipefail

TARGET=""
PATTERN='\.gz$'
BATCH_SIZE=100

while [[ $# -gt 0 ]]; do
    case $1 in
        --pattern) PATTERN=$2; shift 2 ;;
        --batch-size) BATCH_SIZE=$2; shift 2 ;;
        *) TARGET=$1; shift ;;
    esac
done

if [ -z "$TARGET" ]; then
    echo "Usage: $0 [--pattern REGEX] [--batch-size N] <target_dir>" >&2
    exit 1
fi

TARGET=$(realpath "$TARGET")

mapfile -t all_files < <(find "$TARGET" -type f | grep -E "$PATTERN" | sort)
total=${#all_files[@]}
n_tasks=$(( (total + BATCH_SIZE - 1) / BATCH_SIZE ))

if [ -z "${SLURM_ARRAY_TASK_ID:-}" ]; then
    echo "Target:     $TARGET"
    echo "Pattern:    $PATTERN"
    echo "Files:      $total across $n_tasks tasks ($BATCH_SIZE files/task)"
    echo ""
    echo "Submit:"
    echo "  mkdir -p logs"
    echo "  sbatch --array=1-${n_tasks} --output='logs/%x-%A-%a.out' $0 --pattern '$PATTERN' --batch-size $BATCH_SIZE $TARGET"
    exit 0
fi

start=$(( (SLURM_ARRAY_TASK_ID - 1) * BATCH_SIZE ))
end=$(( start + BATCH_SIZE ))
(( end > total )) && end=$total

echo "Task $SLURM_ARRAY_TASK_ID: files $((start + 1))-$end of $total"

failed=0
for (( i=start; i<end; i++ )); do
    f="${all_files[$i]}"
    if ! gzip -t "$f" 2>&1; then
        echo "CORRUPT: $f"
        (( failed++ )) || true
    fi
done

echo "Done: $failed corrupt / $((end - start)) checked"
