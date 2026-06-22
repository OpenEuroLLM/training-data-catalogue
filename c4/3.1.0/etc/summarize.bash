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

python -c "
import sys;
sys.path.append(\"${BASE}/etc\");
import counts;
counts.summarize(\"${ROOT}/openeurollm\", \"${ROOT}/openeurollm/counts.md\", \"md\", False, counts.LANGUAGES);
";
