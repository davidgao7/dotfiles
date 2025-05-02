#!/usr/bin/env bash

brew=(
    icon=􀐛
    label="?"
    padding_left=3
    padding_right=10
    script="$PLUGIN_DIR/brew.sh"

    # ← right here, disable the pill:
    background.drawing=off
)

sketchybar --add event brew_update \
    --add item brew left \
    --set brew "${brew[@]}" \
    --subscribe brew brew_update
