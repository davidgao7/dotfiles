#!/usr/bin/env bash

sketchybar --add item zen left \
    --set zen icon="🧘" \
    label="Zen" \
    padding_left=10 \
    padding_right=10 \
    click_script="$PLUGIN_DIR/zen.sh"
