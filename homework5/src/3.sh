#!/bin/bash

read -p "Enter a filename: " filename

if [ -e "$filename" ]; then 
    echo "File exist in the current directory"
else
    echo "File doesn't exist in the current directory"
fi