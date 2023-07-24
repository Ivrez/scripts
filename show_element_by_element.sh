#!/bin/bash

array=(
  "element1"
  "element2"
  "element3"
  "element4"
  )

clear
for i in "${!array[@]}"
do
  echo "Element number: $((i+1)) of ${#array[@]}"
  echo "Element: ${array[i]}"
done
