#!/bin/bash

#
# for i in ./sorted/???_*/; do echo sbatch etc/count.slurm $i; done > count.trickle
# ../../etc/trickle --start --limit 180 count.trickle
# while true; do ../../etc/trickle --limit 180 count.trickle; sleep 60; done
#

#SBATCH --job-name=count
#SBATCH --output=log/%x-%j.out
#SBATCH --partition=small
#SBATCH --account=project_462000827
#SBATCH --time=72:00:00
#SBATCH --mail-type=FAIL
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=128
#SBATCH --mem-per-cpu=2G

#
# determine our root directory and load a common preamble
#
if [ -n "${SLURM_JOB_ID}" ]; then
  script=$(scontrol show job ${SLURM_JOB_ID} \
  | awk '/^ *Command=/ {sub(/^ *Command=/, "", $1); print $1;}');
  path=$(dirname ${script});
  ROOT="${path%/etc}";
else
  path=$(dirname $0);
  if [ "${path#./}" != "${path}" ]; then
    path="$(pwd)/${path#./}";
  fi
  if [ "${path#/}" = "${path}" ]; then
    if [ "${path}" = "." ]; then
      path="$(pwd)";
    else 
      path="$(pwd)/${path}";
    fi
  fi
  ROOT="${path%/etc}";
fi
source ${ROOT}/../../etc/preamble.sh;

module reset;
module load cray-python;
source ${BASE}/local/bin/activate;

DATA=sorted;

cd ${ROOT};

echo "[$(date +"%Y-%m-%d (%H:%M:%S)")] count.slurm: root in ${ROOT}; target: ${DATA}."
echo "[$(date +"%Y-%m-%d (%H:%M:%S)")] count.slurm: using ${CORES} cores."

#
# for increased parallelization, optionally only process one WDS bin
#
pattern="\\.jsonl\\.zst\$";
if [ -n "${2}" ]; then
  pattern="${2}_[0-9]+\\.jsonl\\.zst\$";
fi

#
# command-line argument is one directory
#
path=$(readlink -e ${1});
if [ -z "${path}" ]; then
  echo "count.slurm: missing or invalid directory argument; exit." >&2;
  exit 1;
fi

python -c "
import sys;
sys.path.append(\"${BASE}/etc\");
import counts;
counts.count_directory(\"${path}\", pattern = \"${pattern}\", cores = ${CORES}, force = False);
"

#
# make sure everything is world-readable (and directories searchable)
#
chmod -R o+rX .;

echo "[$(date +"%Y-%m-%d (%H:%M:%S)")] count.slurm: all files processed."
exit 0;
