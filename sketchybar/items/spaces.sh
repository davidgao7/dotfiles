#!/bin/bash

sketchybar --add event aerospace_workspace_change

for i in {1..9}; do
    sketchybar --add item space.$i left \
        --set space.$i \
        icon="$i" \
        label.drawing=off \
        script="$PLUGIN_DIR/space.sh" \
        icon.font="SF Pro Display:Semibold:13.0" \
        icon.color=0xff777777 \
        icon.highlight_color=0xfff2a2e8 \
        icon.padding_left=5 \
        icon.padding_right=5 \
        --subscribe space.$i mouse.clicked aerospace_workspace_change routine
done

sketchybar --add item space.0 left \
    --set space.0 \
    icon="0" \
    label.drawing=off \
    script="$PLUGIN_DIR/space.sh" \
    icon.font="SF Pro Display:Semibold:13.0" \
    icon.color=0xff777777 \
    icon.highlight_color=0xfff2a2e8 \
    icon.padding_left=5 \
    icon.padding_right=5 \
    --subscribe space.0 mouse.clicked aerospace_workspace_change routine
