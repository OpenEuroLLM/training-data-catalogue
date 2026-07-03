#!/bin/bash

#SBATCH --job-name=redownload-c4
#SBATCH --account=project_462001087
#SBATCH --partition=small
#SBATCH --time=2:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=1750
#SBATCH --output=logs/%x-%j.out

set -euo pipefail

HF="https://huggingface.co/datasets/allenai/c4/resolve/mC4_3.1.0/multilingual"
DIR=/pfs/lustrep1/users/jhelcl/claude-playground/proj-catalogue/c4/3.1.0/etc/tmp

files=(
    c4-gl.00096-00097-00098-00099-00100-00101-00102-00103.json.gz
    c4-en.05848-05849-05850-05851-05852-05853-05854-05855.json.gz
    c4-ru.00512-00513-00514-00515-00516-00517-00518-00519.json.gz
    c4-und.02072-02073-02074-02075-02076-02077-02078-02079.json.gz
)

for f in "${files[@]}"; do
    echo "Downloading $f"
    curl --no-progress-meter --show-error --location --fail --retry 5 --remove-on-error \
        "$HF/$f" -o "$DIR/$f"
    echo "Verifying $f"
    gzip -t "$DIR/$f"
    echo "OK: $f"
done

echo "All done."
