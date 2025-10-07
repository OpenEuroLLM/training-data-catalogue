#!/bin/bash

#
# sbatch etc/intersect.slurm
#

#SBATCH --job-name=intersect
#SBATCH --output=log/%x-%j.out
#SBATCH --partition=small
#SBATCH --account=project_462000131
#SBATCH --time=72:00:00
#SBATCH --mail-type=FAIL
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=100
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

DATA=clean;

cd ${ROOT};

echo "[$(date +"%Y-%m-%d (%H:%M:%S)")] intersect.slurm: root in ${ROOT}; target: ${DATA}."
echo "[$(date +"%Y-%m-%d (%H:%M:%S)")] intersect.slurm: using ${CORES} cores."

#
# no command-line arguments yet (FineWeb data path is hard-coded)
#
/usr/bin/time -v python -c "
import sys;
sys.path.append(\"${BASE}/etc\");
import index;
index.intersect_directory(\"${ROOT}/data\", pattern = \"CC-MAIN-*\", cores = ${CORES});
";

echo "[$(date +"%Y-%m-%d (%H:%M:%S)")] intersect.slurm: all files processed."
exit 0;
