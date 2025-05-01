#!/bin/bash

gpu_top=(
    label.font="$FONT:Semibold:7"
    label=GPU
    icon.drawing=off
    width=0
    padding_right=15
    y_offset=6
)

gpu_percent=(
    label.font="$FONT:Heavy:12"
    label=GPU
    y_offset=-4
    padding_right=15
    width=120
    icon.drawing=off
    update_freq=4
    script="$PLUGIN_DIR/gpu.sh"
)

gpu_graph=(
    graph.color=$ORANGE
    graph.fill_color=$ORANGE
    label.drawing=off
    icon.drawing=off
    background.height=30
    background.drawing=on
    background.color=$TRANSPARENT
)

sketchybar --add item gpu.top right \
    --set gpu.top "${gpu_top[@]}" \
    \
    --add item gpu.percent right \
    --set gpu.percent "${gpu_percent[@]}" \
    \
    --add graph gpu.usage right 75 \
    --set gpu.usage "${gpu_graph[@]}"
