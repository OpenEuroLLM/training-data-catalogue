#!/bin/bash

#
# sbatch etc/bsc.slurm \
#   tmp/eng_Latn \
#   /scratch/project_462000963/datasets/bsc-edu-1.0-hplt-4-unfiltered/clean/eng_Latn
#   tmp/eng_Latn+
#

#SBATCH --job-name=bsc
#SBATCH --output=log/%x-%j.out
#SBATCH --partition=small
#SBATCH --account=project_462000131
#SBATCH --time=72:00:00
#SBATCH --mail-type=FAIL
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=64
#SBATCH --mem-per-cpu=4G

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
export ROOT BASE;

#
# arguments are HPLT 4.0 data, BSC-edu annotations, and output directory respectively
#
source=$(realpath --strip ${1});
if [ -z "${source}" -o ! -d ${source} ]; then
  echo "bsc.slurm: missing or invalid data directory; exit." >&2;
  exit 1;
fi
shift;
bsc=$(realpath --strip ${1});
if [ -z "${bsc}" -o ! -d ${bsc} ]; then
  echo "bsc.slurm: missing or invalid bsc directory; exit." >&2;
  exit 1;
fi
shift;
target=$(realpath --strip ${1});
if [ -z "${target}" -o ! -d ${target} ]; then
  echo "bsc.slurm: missing or invalid target directory; exit." >&2;
  exit 1;
fi
export source bsc target;

module reset;
module load LUMI parallel cray-python;
source ${BASE}/local/bin/activate;

echo "[$(date +"%Y-%m-%d (%H:%M:%S)")] bsc.slurm: root in ${ROOT}; target: ${1}."
echo "[$(date +"%Y-%m-%d (%H:%M:%S)")] bsc.slurm: using ${CORES} cores."

function run() {
  local input=${1};
  local annotation=${bsc}/$(basename ${input});
  local output=${target}/$(basename ${input});
  if [ ! -f ${annotation} ]; then
    echo "bsc.slurm: ${annotation} missing annotations for ${input}; skip." >&2;
    return 1;
  fi
  local command="${BASE}/etc/zstdcat.py --trace --cores 4 --mode json";
  command="${command} --rename bsc-edu-1.0:bsc-edu --compress ${output}";
  echo ${input};
  eval ${command} ${input} ${annotation};
} # run()
export -f run;

PARALLEL="parallel --plain --will-cite";
PARALLEL="${PARALLEL} --group --jobs $[${CORES} / 4]";

#
# finally, iterate through all the languages in this collection of morsels
#
find ${source} -mindepth 1 -maxdepth 1 -name \*.jsonl.zst \
| eval ${PARALLEL} run {};

#
# make sure everything is world-readable (and directories searchable)
#
chmod -R o+rX .;

echo "[$(date +"%Y-%m-%d (%H:%M:%S)")] bsc.slurm: all files processed."
exit 0;
