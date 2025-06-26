#!/bin/bash

THRESHOLD=${1:-50}
MOUNT=${2:-/}
LOG=/var/log/disk.log

USED=$(df -P "$MOUNT" | awk 'NR==2 {gsub("%","",$5); print $5}')

if (( USED >= THRESHOLD )); then
    msg=$(printf '%(%F %T)T WARNING: %s is %d%% full (threshold %d%%)\n' \
             -1 "$MOUNT" "$USED" "$THRESHOLD")
    echo "$msg" >> /var/log/disk.log
fi

if [ -t 1 ]; then
  echo "$msg"
fi
