#!/bin/bash

FILE_PARTS=5

# Check if required tools are available
if command -v gsplit &> /dev/null; then
    TOOL=gsplit
elif command -v split &> /dev/null; then
    TOOL=split
else
    echo "Error: Neither 'gsplit' nor 'split' is installed."
    exit 1
fi

if [ -z "$1" ]; then
    echo "usage: $0 <input_file>"
    exit 1
fi

input_file="$1"

if [ ! -e "$input_file" ]; then
    echo "$input_file not found"
    exit 1
fi

# File name
file_n="${input_file%.*}"
# File extention
file_ext="${input_file##*.}"
# Handle cases where the file doesn't have an extension
[ "$file_n" == "$file_ext" ] && file_n="input_file"

echo "$file_n"
echo "$file_ext"

total_lines=$(wc -l < "$input_file")
lines_per_part=$((total_lines / $FILE_PARTS))

$TOOL --numeric-suffixes=1 --additional-suffix=".$file_ext" -l "$lines_per_part" "$input_file" "$file_n"

