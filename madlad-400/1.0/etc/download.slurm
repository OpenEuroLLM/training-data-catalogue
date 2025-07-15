#!/bin/bash

#SBATCH --job-name=download
#SBATCH --partition=small
#SBATCH --account=project_462000131
#SBATCH --time=72:00:00
#SBATCH --mail-type=FAIL
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
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

TARGET="allenai/MADLAD-400";
REVISION="v1.0";
HF="https://huggingface.co/datasets/${TARGET}/resolve/${REVISION}/";
DATA=clean;

cd ${ROOT};

echo "[$(date +"%Y-%m-%d (%H:%M:%S)")] download.slurm: root in ${ROOT}; target: ${DATA}."
echo "[$(date +"%Y-%m-%d (%H:%M:%S)")] download.slurm: using ${CORES} cores."

if [ ! -d ./${DATA} ]; then mkdir ./${DATA}; fi
cd ./${DATA}

CURL="/usr/bin/curl --no-progress-meter --show-error --create-dirs --location"
CURL="${CURL} --globoff --remote-time";
CURL="${CURL} --fail --retry 5 --remove-on-error";
CORES=${SLURM_CPUS_ON_NODE:-8};
CURL="${CURL} --parallel --parallel-max ${CORES}";

URL=all.url;
LOG=curl.log;
cat /dev/null > ${URL};
cat /dev/null > ${LOG};

#
# determine list of data files and create download map
#
python -c "import sys; sys.path.append(\"${BASE}/etc\"); import huggingface as hf; hf.api_retrieve_files(\"${TARGET}\", \"${REVISION}\", \"^data/[^/]+/[^/]+_clean_\");" \
| while read line; do \
  target=${line#data/};
  path=${target%/*};
  file=${target##*/};
  header=${path}/.${file%jsonl.gz}http
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
CURL="${CURL} --write-out \"%{stderr}{\\\"content-type\\\": \\\"%header{content-type}\\\", \\\"content-length\\\": %header{content-length}}\\n%{json}\\n\"";

echo $CURL

#
# now download all files that are missing or appear out of date
#
eval ${CURL} --config ${URL} 2>> ${LOG};
       
#
# make sure everything is world-readable (and directories searchable)
#
chmod -R o+rX .;

echo "[$(date +"%Y-%m-%d (%H:%M:%S)")] download.slurm: all downloads complete."
exit 0;
