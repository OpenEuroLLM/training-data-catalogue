#!/bin/bash

#SBATCH --job-name=verify-c4
#SBATCH --account=project_462001087
#SBATCH --partition=small
#SBATCH --time=4:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=1750
#SBATCH --output=logs/%x-%A-%a.out

set -euo pipefail

DATA_DIR=/pfs/lustrep2/scratch/project_462000953/training/catalogue/c4/3.1.0
BATCH_SIZE=100

mapfile -t all_files < <(find "$DATA_DIR" -name "*.json.gz" | sort)
total=${#all_files[@]}
n_tasks=$(( (total + BATCH_SIZE - 1) / BATCH_SIZE ))

if [ -z "${SLURM_ARRAY_TASK_ID:-}" ]; then
    echo "Total files: $total, batch size: $BATCH_SIZE"
    echo "Usage: mkdir -p logs && sbatch --array=1-${n_tasks} verify.slurm"
    exit 1
fi

start=$(( (SLURM_ARRAY_TASK_ID - 1) * BATCH_SIZE ))
end=$(( start + BATCH_SIZE ))
(( end > total )) && end=$total

failed=0
for (( i=start; i<end; i++ )); do
    f="${all_files[$i]}"
    if ! gzip -t "$f" 2>&1; then
        echo "CORRUPT: $f"
        (( failed++ )) || true
    fi
done

echo "Done: $failed corrupt / $((end - start)) checked in task $SLURM_ARRAY_TASK_ID"
