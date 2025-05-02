#!/bin/bash

WORKSPACE_ID="${NAME#*.}"
FOCUSED="$(aerospace list-workspaces --focused)"

if [[ "$WORKSPACE_ID" == "$FOCUSED" ]]; then
    sketchybar --set "$NAME" \
        icon="$WORKSPACE_ID" \
        icon.highlight=true \
        label.drawing=off
else
    sketchybar --set "$NAME" \
        icon="$WORKSPACE_ID" \
        icon.highlight=false \
        label.drawing=off
fi
