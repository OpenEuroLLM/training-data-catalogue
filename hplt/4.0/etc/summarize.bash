#!/bin/bash

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

for data in clean; do # oor noisy clean; do

python -c "
import sys;
sys.path.append(\"${BASE}/etc\");
import counts;
counts.summarize(\"${ROOT}/${data}\", \"${ROOT}/counts.md\", \"md\", False, counts.LANGUAGES, None);
  ";

python -c "
import sys;
sys.path.append(\"${BASE}/etc\");
import counts;
counts.summarize(\"${ROOT}/${data}\", \"${ROOT}/${data}/manifest.json\", \"json\", True, None, None, counts.HPLT[\"4.0\"], prefix = \"https://data.hplt-project.org/four/${data}\");
  ";

done
