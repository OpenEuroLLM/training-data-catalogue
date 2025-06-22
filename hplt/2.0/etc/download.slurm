#!/bin/bash

#SBATCH --job-name=download
#SBATCH --partition=small
#SBATCH --account=project_462000131
#SBATCH --time=72:00:00
#SBATCH --mail-type=FAIL
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=64
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

DATA=cleaned;

CURL="/usr/bin/curl --no-progress-meter --show-error --create-dirs";
CORES=${SLURM_CPUS_ON_NODE:-8};
CURL="${CURL} --parallel --parallel-immediate --parallel-max ${CORES}";

cd ${ROOT};

echo "[$(date +"%Y-%m-%d (%H:%M:%S)")] download.slurm: root in ${ROOT}; target: ${DATA}."
echo "[$(date +"%Y-%m-%d (%H:%M:%S)")] download.slurm: using ${CORES} cores."

if [ ! -d ./${DATA} ]; then mkdir ./${DATA}; fi
cd ./${DATA}

URL=all.url;
MD5=all.md5;
LOG=curl.log;
cat /dev/null > ${URL};
cat /dev/null > ${MD5};
cat /dev/null > ${LOG};

set -x

#
# create fresh download maps for the actual files and their checksums
#
${CURL} https://data.hplt-project.org/two/${DATA}/hplt_monolingual_map_${DATA}_2.0.txt \
| while read line; do \
  prefix=${line%/*/*};
  target=${line#${prefix}/};
  #
  # make sure we always fetch up-to-date checksums
  #
  /bin/rm -f ${target}.md5;
  echo "url ${line}.md5" >> ${MD5};
  echo "output ${target}.md5" >> ${MD5};
  if [ ! -f ${target} ]; then 
    echo "url ${line}" >> ${URL};
    echo "output ${target}" >> ${URL};
  fi;
done;

echo "[$(date +"%Y-%m-%d (%H:%M:%S)")] download.slurm: MD5 directives (${MD5}):"
cat ${MD5};
echo;
echo "[$(date +"%Y-%m-%d (%H:%M:%S)")] download.slurm: URL directives (${URL}):"
cat ${URL};
echo;

#
# make sure we have current checksum files for everything
#
eval ${CURL} --config ${MD5} 2>> ${LOG};

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

for i in ???_*; do
  echo "directory: $i"; cd $i;
  for j in *.md5; do
    if md5sum --check $j; then
      true;
    else
      mv ${j%%.md5} ${j%%.md5}-;
    fi
  done;
  cd ..;
done | 2>&1 tee md5sum.log

