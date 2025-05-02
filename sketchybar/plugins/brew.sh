#!/bin/bash
source "$CONFIG_DIR/colors.sh"

# Count both formulae and casks:
COUNT=$(
    brew outdated --json=v2 |
        jq '[.formulae, .casks] | map(length) | add'
)

COLOR=$RED

case "$COUNT" in
[1-5][0-9]) COLOR=$ORANGE ;;
[1-9][0-9][0-9]*) COLOR=$MAGENTA ;;
[1-2][0-9]) COLOR=$YELLOW ;;
[1-9]) COLOR=$WHITE ;;
0)
    COLOR=$GREEN
    COUNT=􀆅
    ;;
esac

sketchybar --set "$NAME" \
    label="$COUNT" \
    icon.color=$COLOR
