#!/bin/bash

MONITOR_DIR="$HOME/watch"
EXCLUDE='.*\.back$' 

inotifywait -m -e create --exclude "$EXCLUDE" --format '%w%f' "$MONITOR_DIR" | while read NEWFILE
do
echo "New file detected: $NEWFILE"
cat "$NEWFILE"
mv "$NEWFILE" "$NEWFILE".back
echo "$NEWFILE is renamed"
done