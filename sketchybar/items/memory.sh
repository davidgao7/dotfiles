#!/bin/bash

ram=(
    icon= # You confirmed this works
    icon.font="JetBrainsMono Nerd Font:Regular:14.0"
    icon.color=$ORANGE
    label.drawing=on # Required to show the memory usage
    update_freq=3
    script="$PLUGIN_DIR/memory.sh"
)

sketchybar --add item ram left \
    --set ram "${ram[@]}"
