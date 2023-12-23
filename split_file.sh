#!/bin/bash

FILE_PARTS=5
# gsplit for mac: brew install coreutils
TOOL=gsplit #or split

if [ -z "$1" ]; then
    echo "usage: $0 <input_file>"
    exit 1
fi

input_file="$1"

if [ ! -e "$input_file" ]; then
    echo "$input_file not found"
    exit 1
fi

#file name
file_n="${input_file%.*}"
#file extention
file_ext="${input_file##*.}"

total_lines=$(wc -l < "$input_file")
lines_per_part=$((total_lines / $FILE_PARTS))

$TOOL --numeric-suffixes=1 --additional-suffix=".$file_ext" -l "$lines_per_part" "$input_file" "$file_n"
