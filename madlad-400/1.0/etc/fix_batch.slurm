#!/bin/bash

#SBATCH --job-name=fix-madlad-batch
#SBATCH --account=project_462001087
#SBATCH --partition=small
#SBATCH --time=72:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=1750
#SBATCH --output=logs/%x-%A-%a.out

set -euo pipefail

module --quiet purge
module load LUMI

source /projappl/project_462000953/jhelcl/training-data-catalogue/env/bin/activate

if [ -z "${SLURM_ARRAY_TASK_ID:-}" ]; then
    n=$(wc -l < filelist.txt)
    echo "Usage: sbatch --array=1-${n} fix_batch.slurm"
    exit 1
fi

read -ra files < <(sed -n "${SLURM_ARRAY_TASK_ID}p" filelist.txt)

for input_file in "${files[@]}"; do
    output_file="${input_file/\/clean\//\/fixed\/}"
    output_file="${output_file/.jsonl.gz/.jsonl.zst}"
    python fix_single.py \
        --input-file "$input_file" \
        --output-file "$output_file" \
        --threads "$SLURM_CPUS_PER_TASK"
done
