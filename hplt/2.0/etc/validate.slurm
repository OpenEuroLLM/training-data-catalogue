#!/bin/bash

#SBATCH --job-name=validate
#SBATCH --partition=small
#SBATCH --account=project_462000131
#SBATCH --time=72:00:00
#SBATCH --mail-type=FAIL
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=128
#SBATCH --mem-per-cpu=1G

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
module load LUMI cURL parallel;

DATA=cleaned;

cd ${ROOT};

echo "[$(date +"%Y-%m-%d (%H:%M:%S)")] validate.slurm: root in ${ROOT}; target: ${DATA}."
echo "[$(date +"%Y-%m-%d (%H:%M:%S)")] validate.slurm: using ${CORES} cores."

if [ ! -d ./${DATA} ]; then mkdir ./${DATA}; fi
cd ./${DATA}

CURL="curl --disable --no-progress-meter --show-error --create-dirs --location";
CURL="${CURL} --fail --retry 2";
CORES=${SLURM_CPUS_ON_NODE:-8};
CURL="${CURL} --parallel --parallel-max ${CORES}";

MD5=all.md5;
LOG=md5sum.log;
cat /dev/null > ${MD5};
cat /dev/null > ${LOG};

#
# create fresh download maps for the checksum files
#
${CURL} https://data.hplt-project.org/two/${DATA}/hplt_monolingual_map_${DATA}_2.0.txt \
| while read line; do \
  prefix=${line%/*/*};
  target=${line#${prefix}/};
  path=${target%/*};
  file=${target#${path}/};
  #
  # ignore existing files; we always want to use up-to-date checksums
  #
  /bin/rm -f ${path}/.${file}.md5;
  echo "url ${line}.md5" >> ${MD5};
  echo "output ${path}/.${file}.md5" >> ${MD5};
done;

echo "[$(date +"%Y-%m-%d (%H:%M:%S)")] validate.slurm: MD5 directives (${MD5}):"
cat ${MD5};
echo;

#
# now make sure we have current checksum files for everything
#
eval ${CURL} --config ${MD5}

function validate() {
  file=${1};
  path=${file%/*};
  file=${file#${path}/};
  if [ ! -d ${path} ]; then
    echo "invalid sub-directory: ${path}." >&2;
    return 1;
  fi
  (
    cd ${path};
    target=$(awk '{print $2}' ${file});
    if [ ! -f ${target} ]; then
      echo "missing target file: ${path}/${target#./}." >&2;
      return 1;
    fi
    if md5sum --check --status ${file}; then
      echo "check-sum validated: ${path}/${target#./}." >&2;
    else
      echo "check-sum failure; removing: ${path}/${target#./}." >&2;
      /bin/rm ${target};
    fi
  )
} # validate()
export -f validate;

PARALLEL="parallel --plain --will-cite";
PARALLEL="${PARALLEL} --group --jobs ${CORES}";

#
# finally, iterate through all the check-sum files
#
egrep "^output " ${MD5} | sed "s/output //" \
| eval ${PARALLEL} validate {};

#
# make sure everything is world-readable (and directories searchable)
#
chmod -R o+rX .;

echo "[$(date +"%Y-%m-%d (%H:%M:%S)")] validate.slurm: all files processed."
