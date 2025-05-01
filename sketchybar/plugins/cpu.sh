#!/bin/bash

CPU_USAGE=$(top -l 2 | grep -E "^CPU" | tail -1 | awk '{used = $3 + $5; sub("%","",used); print int(used)"%"}')
sketchybar --set "$NAME" label="$CPU_USAGE"
