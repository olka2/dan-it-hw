#!/bin/bash

read -p "Please, enter a file name: " filename

if [[ -r "$filename" ]]; then 
  cat -- "$filename"
else
  echo "Error: '$filename' not found or not readable" >&2
  exit 1
fi