#!/bin/bash

filename="$1"

if [ -f "$filename" ]; then
    lines=$(wc -l < "$filename")
    echo "The file '$filename' has $lines lines."
else
    echo "Error: File '$filename' does not exist."
fi