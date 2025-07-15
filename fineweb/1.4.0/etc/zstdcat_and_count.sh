#!/bin/bash

set -exuo pipefail
zstdcat $1 | wc -l > $2
