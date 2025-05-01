#!/bin/bash

if [[ $(uname -m) == "arm64" ]]; then
    GPU_LOAD=$(/usr/bin/sudo /usr/bin/powermetrics --samplers gpu_power -n 1 2>/dev/null |
        awk -F ':' '/GPU HW active residency/ {gsub(/%/, "", $2); print int($2)}')

    GPU_TOP=$(ps -arcwwwxo pid,comm | grep -iE 'chrome|neural|metal|gpu|windowserver' | head -n 1)
    GPU_PID=$(echo "$GPU_TOP" | awk '{print $1}')
    GPU_PROC=$(echo "$GPU_TOP" | awk '{print $2}')

    GPU_LOAD=${GPU_LOAD:-0}
    GPU_PID=${GPU_PID:-"–"}
    GPU_PROC=${GPU_PROC:-"NoProc"}

    sketchybar --set gpu.percent label="${GPU_LOAD}%"
    sketchybar --push gpu.usage value="$GPU_LOAD $GPU_PROC ($GPU_PID)"
else
    sketchybar --set gpu.percent label="N/A"
fi
