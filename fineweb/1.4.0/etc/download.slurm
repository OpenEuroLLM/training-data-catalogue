#!/bin/bash

#SBATCH --job-name=download
#SBATCH --partition=small
#SBATCH --account=project_462000131
#SBATCH --time=72:00:00
#SBATCH --mail-type=FAIL
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=128
#SBATCH --mem-per-cpu=1G

set -x;
source $(dirname $0)/../../../etc/preamble.sh;

DATA=edu;
HF="https://huggingface.co/datasets/HuggingFaceFW/fineweb-edu/resolve/v1.4.0/";

cd ${ROOT};

echo "[$(date +"%Y-%m-%d (%H:%M:%S)")] download.slurm: root in ${ROOT}; target: ${DATA}."
echo "[$(date +"%Y-%m-%d (%H:%M:%S)")] download.slurm: using ${CORES} cores."

if [ ! -d ./${DATA} ]; then mkdir ./${DATA}; fi
cd ./${DATA}

CURL="/usr/bin/curl --no-progress-meter --show-error --create-dirs";
CURL="${CURL} --fail --retry 1 --remove-on-error";
CORES=${SLURM_CPUS_ON_NODE:-8};
CURL="${CURL} --parallel --parallel-immediate --parallel-max ${CORES}";

URL=all.url;
LOG=curl.log;
cat /dev/null > ${URL};
cat /dev/null > ${LOG};

python -c "import sys; sys.path.append(\"${BASE}/etc\"); import huggingface as hf; hf.retrieve_files(\"HuggingFaceFW/fineweb-edu\", \"^data/\");" \
| while read line; do \
  target=${line#data/};
  if [ ! -f ${target} ]; then 
    echo "url ${HF}${line}" >> ${URL};
    echo "output ${target}" >> ${URL};
  fi;
done;

echo "[$(date +"%Y-%m-%d (%H:%M:%S)")] download.slurm: URL directives (${URL}):"
cat ${URL};
echo;

#
# enable detailed download statistics
#
CURL="${CURL} --write-out '%{stderr} %{json}'";

#
# now download all files that are missing or appear out of date
#
eval ${CURL} --config ${URL} 2>> ${LOG};
       
#
# make sure everything is world-readable (and directories searchable)
#
chown -R o+rX .;

echo "[$(date +"%Y-%m-%d (%H:%M:%S)")] download.slurm: all downloads complete."
exit 0;
