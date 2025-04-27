#!/bin/bash

DIRECTION="$1" # "left" or "right"
STEP=${2:-20}
YABAI="/opt/homebrew/bin/yabai" # (adjust if necessary)

if [[ "$DIRECTION" == "left" ]]; then
    has_neighbor=$($YABAI -m query --windows --window | jq '.["has-left"]')
    if [[ "$has_neighbor" == "true" ]]; then
        $YABAI -m window --resize left:-$STEP:0
    else
        $YABAI -m window --resize right:-$STEP:0
    fi
elif [[ "$DIRECTION" == "right" ]]; then
    has_neighbor=$($YABAI -m query --windows --window | jq '.["has-right"]')
    if [[ "$has_neighbor" == "true" ]]; then
        $YABAI -m window --resize right:$STEP:0
    else
        $YABAI -m window --resize left:$STEP:0
    fi
else
    echo "Usage: left|right step"
    exit 1
fi
