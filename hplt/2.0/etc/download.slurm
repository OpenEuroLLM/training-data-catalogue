#!/bin/bash

#SBATCH --job-name=download
#SBATCH --partition=small
#SBATCH --account=project_462000131
#SBATCH --time=12:00:00
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

CORES=${SLURM_CPUS_ON_NODE:-8};

CURL="/usr/bin/curl --silent --show-error --create-dirs --parallel-max ${CORES}";
URL=cleaned.url;
MD5=cleaned.md5;
cat /dev/null > ${URL};
cat /dev/null > ${MD5};

cd ${ROOT};

echo "download.slurm: using ${CORES} cores."

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
    /bin/rm -f ${target};
  done;

#
# make sure we have current checksum files for everything
#
${CURL} --config ${MD5};

#
# now download all files that are missing or appear out of date
#
${CURL} --config ${URL};
