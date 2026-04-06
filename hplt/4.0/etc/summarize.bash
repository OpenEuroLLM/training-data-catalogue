#!/bin/bash

#
#

#
# determine our root directory and load a common preamble
#
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
source ${ROOT}/../../etc/preamble.sh;

module reset;
module load cray-python;
source ${BASE}/local/bin/activate;

DATA=$(readlink -e ${1});
if [ -z "${path}" ]; then
  echo "count.slurm: missing or invalid directory argument; exit." >&2;
  exit 1;
fi

python -c "
import sys;
sys.path.append(\"${BASE}/etc\");
import counts;
counts.summarize(\"${DATA}\", \"${DATA}/counts.md\", \"md\", False, counts.LANGUAGES, None);
";

python -c "
import sys;
sys.path.append(\"${BASE}/etc\");
import counts;
counts.summarize(\"${DATA}\", \"${DATA}/manifest.json\", \"json\", True, None, None, counts.HPLT[\"4.0\"]);
";
