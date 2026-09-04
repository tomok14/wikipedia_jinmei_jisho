#!/usr/bin/bash

#./bin/downarc_legacy.sh -a
if ! downarc.sh -a; then
    echo "ERROR: downarc.sh failed."
    exit 1
fi
#FILE=$(ls jawiki*.bz2 | tail -1)
shopt -s nullglob
files=(jawiki*.bz2)
build.sh "${files[@]}"
