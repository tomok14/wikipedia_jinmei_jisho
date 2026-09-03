#!/usr/bin/bash

#./bin/downarc_legacy.sh -a
downarc.sh -a
if [ $? -ne 0 ]; then
    echo "ERROR: downarc.sh failed."
    exit 1
fi
#FILE=$(ls jawiki*.bz2 | tail -1)
shopt -s nullglob
files=(jawiki*.bz2)
file=${files[-1]}
echo "$file"
build.sh "$file"
