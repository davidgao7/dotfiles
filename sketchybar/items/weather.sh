#!/bin/sh

sketchybar --add item weather right \
    --set weather \
    icon=󰖐 \
    script="$PLUGIN_DIR/weather.sh" \
    scroll_texts=on \
    label.max_chars=25 \
    update_freq=1500 \
    --subscribe weather mouse.clicked
