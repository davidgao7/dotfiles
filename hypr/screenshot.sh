#!/usr/bin/env bash
path="$HOME/screenshots/$(date +%Y-%m-%d_%H-%M-%S).png"
grim -g "$(slurp)" "$path"
if [ $? -eq 0 ] && [ -f "$path" ]; then
  notify-send "📷 Screenshot saved" "$(basename "$path") → ~/screenshots/"
fi
