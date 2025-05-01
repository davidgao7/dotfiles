#!/bin/bash

memory_top=(
    label.font="$FONT:Semibold:7"
    label=RAM
    icon.drawing=off
    width=0
    padding_right=15
    y_offset=6
)

memory_percent=(
    label.font="$FONT:Heavy:12"
    label=RAM
    y_offset=-4
    padding_right=15
    width=55
    icon.drawing=off
    update_freq=4
    script="$PLUGIN_DIR/memory.sh"
)

memory_graph=(
    graph.color=$GREEN
    graph.fill_color=$GREEN
    label.drawing=off
    icon.drawing=off
    background.height=30
    background.drawing=on
    background.color=$TRANSPARENT
)

sketchybar --add item memory.top left \
    --set memory.top "${memory_top[@]}" \
    \
    --add item memory.percent left \
    --set memory.percent "${memory_percent[@]}" \
    \
    --add graph memory.used left 75 \
    --set memory.used "${memory_graph[@]}"
