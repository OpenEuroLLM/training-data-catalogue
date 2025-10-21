#!/bin/bash

#
# for i in ./clean/*; do echo sbatch etc/count.slurm $i; done > count.trickle
# trickle --start --limit 180 count.trickle
# while true; do trickle --limit 180 count.trickle; sleep 60; done
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

DATA=sorted;

python -c "
import sys;
sys.path.append(\"${BASE}/etc\");
import counts;
counts.summarize(\"${ROOT}/${DATA}\", \"${ROOT}/counts.md\", \"md\", False, counts.LANGUAGES, None);
";

python -c "
import sys;
sys.path.append(\"${BASE}/etc\");
import counts;
counts.summarize(\"${ROOT}/${DATA}\", \"${ROOT}/${DATA}/manifest.json\", \"json\", True, None, None, counts.HPLT[\"3.0\"]);
";
