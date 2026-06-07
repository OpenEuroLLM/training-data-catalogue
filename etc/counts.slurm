#!/bin/bash

#SBATCH --job-name=counts
#SBATCH --account=project_462000963
#SBATCH --partition=small
#SBATCH --time=12:00:00
#SBATCH --ntasks=8
#SBATCH --cpus-per-task=16
#SBATCH --mem-per-cpu=1G
#SBATCH --output=logs/%x-%j.out

set -euo pipefail

module --quiet purge
module load LUMI
module load parallel

source /projappl/project_462000953/jhelcl/training-data-catalogue/env/bin/activate

array_offset=0
target=""
pattern="\\.jsonl\\.zst\$"

while [[ $# -gt 0 ]]; do
    case $1 in
        --array-offset)
            array_offset=$2
            shift 2
            ;;
        --pattern)
            pattern=$2
            shift 2
            ;;
        *)
            if [ -z "$target" ]; then
                target=$1
            fi
            shift
            ;;
    esac
done

if [ -z "$target" ]; then
    echo "Usage: sbatch counts.slurm [--pattern P] <target_directory>"
    exit 1
fi

TARGET=$(realpath "$target")

mapfile -t subdirs < <(find "$TARGET" -mindepth 1 -maxdepth 1 -type d | sort)
echo "Found ${#subdirs[@]} subdirectories to process."

for subdir in "${subdirs[@]}"; do
    if ! find "$subdir" -maxdepth 1 -type f -print0 | grep -z -q -E "$pattern"; then
        echo "Skipping $subdir (no matching files)"
        continue
    fi

    echo "Starting processing for: $subdir"
    srun --ntasks=1 --nodes=1 --cpus-per-task="${SLURM_CPUS_PER_TASK:-1}" --exclusive \
         python counts.py count "$subdir" --pattern "$pattern" --cores "${SLURM_CPUS_PER_TASK:-1}" &
done

echo "$(date): All jobs started, waiting for completion..."
wait
echo "$(date): All conversions completed"
