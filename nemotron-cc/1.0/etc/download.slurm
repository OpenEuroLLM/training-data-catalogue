#!/bin/bash

#SBATCH --job-name=download
#SBATCH --partition=small
#SBATCH --account=project_462000131
#SBATCH --time=72:00:00
#SBATCH --mail-type=FAIL
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=128
#SBATCH --mem-per-cpu=1G

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
ROOT=$(realpath ${ROOT});

DATA=data;
CC=https://data.commoncrawl.org/

CURL="/usr/bin/curl --no-progress-meter --show-error --create-dirs";
CORES=${SLURM_CPUS_ON_NODE:-8};
CURL="${CURL} --parallel --parallel-immediate --parallel-max ${CORES}";

cd ${ROOT};

echo "[$(date +"%Y-%m-%d (%H:%M:%S)")] download.slurm: root in ${ROOT}; target: ${DATA}."
echo "[$(date +"%Y-%m-%d (%H:%M:%S)")] download.slurm: using ${CORES} cores."

if [ ! -d ./${DATA} ]; then mkdir ./${DATA}; fi
cd ./${DATA}

URL=all.url;
LOG=curl.log;
cat /dev/null > ${URL};
cat /dev/null > ${LOG};

set -x

#
# create fresh download maps for the actual files
#
${CURL} ${CC}contrib/Nemotron/Nemotron-CC/data-jsonl.paths.gz | gzip -dc \
| while read line; do \
  prefix=${line%/*};
  file=${line##*/};  
  prefix=${line#contrib/Nemotron/Nemotron-CC/data-jsonl/};
  quality=${prefix%%/*};
  quality=${quality#quality=};
  kind=${prefix#quality=*/};
  kind=${kind%%/*};
  kind=${kind#kind=};
  type=${prefix#quality=*/kind=*/};
  type=${type%%/*};
  type=${type#kind2=};
  quality=${quality#quality=};
  target=${quality}/${kind}/;
  if [ "${type}" != "${kind}" ]; then target=${target}${type}/; fi
  target=${target}${file};
  echo ${target}
  if [ ! -f ${target} ]; then 
    echo "url ${CC}${line}" >> ${URL};
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

echo "[$(date +"%Y-%m-%d (%H:%M:%S)")] download.slurm: all downloads complete."
exit 0;
