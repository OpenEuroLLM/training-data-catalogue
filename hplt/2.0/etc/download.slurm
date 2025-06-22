#!/bin/bash

#SBATCH --job-name=download
#SBATCH --partition=small
#SBATCH --account=project_462000131
#SBATCH --time=72:00:00
#SBATCH --mail-type=FAIL
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=64
#SBATCH --mem-per-cpu=1G

path=$(dirname $0)
if [ "${path#./}" != "${path}" ]; then
  path="$(pwd)/${path#./}"
fi
if [ "${path#/}" = "${path}" ]; then
  if [ "${path}" = "." ]; then
    path="$(pwd)";
  else 
    path="$(pwd)/${path}"
  fi
fi
ROOT="${path%/etc}";
ROOT=/scratch/project_462000953/training/catalogue/hplt/2.0;

CURL="/usr/bin/curl --no-progress-meter --show-error --create-dirs";
CORES=${SLURM_CPUS_ON_NODE:-8};
CURL="${CURL} --parallel --parallel-immediate --parallel-max ${CORES}";

cd ${ROOT};

echo "[$(date +"%Y-%m-%d (%H:%M:%S)")] download.slurm: using ${CORES} cores."
echo "[$(date +"%Y-%m-%d (%H:%M:%S)")] download.slurm: root in ${ROOT}."

if [ ! -d ./cleaned ]; then mkdir ./cleaned; fi
cd ./cleaned

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
${CURL} https://data.hplt-project.org/two/cleaned/hplt_monolingual_map_cleaned_2.0.txt \
| while read line; do \
    prefix=${line%/*/*};
    target=${line#${prefix}/};
    echo "url ${line}" >> ${URL};
    echo "output ${target}" >> ${URL};
    echo "time-cond ${target}" >> ${URL};
    echo "url ${line}.md5" >> ${MD5};
    echo "output ${target}.md5" >> ${MD5};
    #
    # make sure we always fetch up-to-date checksums
    #
    /bin/rm -f ${target}.md5;
  done;

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

