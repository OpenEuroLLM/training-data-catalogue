#!/bin/bash

#
# for i in ./sorted/*; do sbatch etc/index.slurm $i; done
#

#SBATCH --job-name=index
#SBATCH --output=log/%x-%j.out
#SBATCH --partition=small
#SBATCH --account=project_462000131
#SBATCH --time=72:00:00
#SBATCH --mail-type=FAIL
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=32G

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

cd ${ROOT};

echo "[$(date +"%Y-%m-%d (%H:%M:%S)")] index.slurm: root in ${ROOT}."
echo "[$(date +"%Y-%m-%d (%H:%M:%S)")] index.slurm: using ${CORES} cores."

#
# command-line arguments can be directories; otherwise glob ourselves
#
for i in ${*:-*}; do
  path=$(readlink -e ${i});
  if [ -z "${path}" ]; then continue; fi
  if [ -f ${path}/.domains.zst -a ${path}/.urls.zst -a ${path}/.signatures.zst ]; then continue; fi
  /usr/bin/time -v python -c "
import sys;
sys.path.append(\"${BASE}/etc\");
import index;
index.index_directory(\"${path}\", cores = ${CORES});
  "
done;

#
# make sure everything is world-readable (and directories searchable)
#
chmod -R o+rX .;

echo "[$(date +"%Y-%m-%d (%H:%M:%S)")] count.slurm: all files processed."
exit 0;
