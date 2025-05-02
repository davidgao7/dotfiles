#!/usr/bin/env bash

brew_item=(
    icon=􀐛
    label="?"
    padding_left=3
    padding_right=10

    update_freq=1800
    click_script="$PLUGIN_DIR/brew.sh"
    script="$PLUGIN_DIR/brew.sh"
)

sketchybar \
    --add item brew left \
    --set brew "${brew_item[@]}"
