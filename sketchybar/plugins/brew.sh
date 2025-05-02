#!/usr/bin/env bash

export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
source "$CONFIG_DIR/colors.sh"

NAME="brew"
ICON=􀐛
spinner=("|" "/" "-" "\\")
i=0

BREW_BIN="$(command -v brew)"

# 1. Start brew update + outdated count in background
TEMP_FILE="$(mktemp)"
{
    "$BREW_BIN" update >/dev/null 2>&1
    "$BREW_BIN" outdated --json=v2 2>/dev/null |
        jq '[.formulae, .casks] | map(length) | add' >"$TEMP_FILE"
} &
pid=$!

# 2. Animate spinner as label while it's working
while kill -0 "$pid" 2>/dev/null; do
    sketchybar --set "$NAME" label="${spinner[i]}"
    i=$(((i + 1) % ${#spinner[@]}))
    sleep 0.1
done

# 3. Read count from temp file
COUNT=$(cat "$TEMP_FILE")
rm "$TEMP_FILE"
[[ -z "$COUNT" ]] && COUNT=0

# 4. Set display and color
if [[ $COUNT -eq 0 ]]; then
    DISPLAY=􀆅
    COLOR=$GREEN
else
    DISPLAY=$COUNT
    COLOR=$RED
fi

# 5. Push to SketchyBar
sketchybar --set "$NAME" \
    icon=$ICON \
    label="$DISPLAY" \
    icon.color=$COLOR
