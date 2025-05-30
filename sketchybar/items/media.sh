#!/bin/bash

sketchybar --add item media right \
    --set media script="$PLUGIN_DIR/media.sh" \
    icon=􀑪 \
    icon.color=0xff58d1fc \
    label.color=0xff58d1fc \
    label.max_chars=25 \
    scroll_texts=on \
    label.shadow.drawing=off \
    scroll_duration=500 \
    update_freq=5 \
    --subscribe media media_change
