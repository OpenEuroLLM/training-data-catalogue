#!/bin/bash

#
# for i in ./clean/*; do if [ ! -h $i ]; then echo sbatch etc/count.slurm $i; fi; done > count.trickle
# trickle --start --limit 180 count.trickle
# while true; do trickle --limit 180 count.trickle; sleep 60; done
#

#SBATCH --job-name=count
#SBATCH --partition=small
#SBATCH --account=project_462000131
#SBATCH --time=72:00:00
#SBATCH --mail-type=FAIL
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=128
#SBATCH --mem-per-cpu=2G

#
# determine our root directory and load a common preabmle
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
source ${BASE}/python/bin/activate;

DATA=clean;

cd ${ROOT};

echo "[$(date +"%Y-%m-%d (%H:%M:%S)")] count.slurm: root in ${ROOT}; target: ${DATA}."
echo "[$(date +"%Y-%m-%d (%H:%M:%S)")] count.slurm: using ${CORES} cores."

#
# command-line arguments can be directories; otherwise glob ourselves
#
for i in ${*:-*}; do
  path=$(readlink -e ${i});
  if [ -z "${path}" ]; then continue; fi
  if [ -f ${i}/.counts.json ]; then continue; fi  
  python -c "
import sys;
sys.path.append(\"${BASE}/etc\");
import counts;
counts.count_directory(\"${path}\", pattern = \"\\\\.gz\$\", cores = ${CORES});
  "
done;

#
# make sure everything is world-readable (and directories searchable)
#
chmod -R o+rX .;

echo "[$(date +"%Y-%m-%d (%H:%M:%S)")] count.slurm: all files processed."
exit 0;
