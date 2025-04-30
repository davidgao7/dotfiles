#!/bin/bash

if [[ $(uname -m) == "arm64" ]]; then
    GPU_LOAD=$(sudo /usr/bin/powermetrics --samplers gpu_power -n 1 2>/dev/null | awk '/GPU HW active residency/ {print int($5)}')
    GPU_LOAD=${GPU_LOAD:-0}
    sketchybar --set gpu.percent label="${GPU_LOAD}%"
    sketchybar --push gpu.usage value "$GPU_LOAD"
else
    sketchybar --set gpu.percent label="N/A"
fi
