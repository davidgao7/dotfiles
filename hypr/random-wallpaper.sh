#!/bin/bash

LOG_FILE="/tmp/swww_log.txt"
echo "--- Starting wallpaper script ---" >"$LOG_FILE"
echo "Attempting to change wallpaper..." >>"$LOG_FILE"

WALLPAPER_DIR="$HOME/anime/"
echo "Wallpaper directory: $WALLPAPER_DIR" >>"$LOG_FILE"

WALLPAPERS=($(/usr/bin/find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.gif" -o -name "*.svg" -o -name "*.webp" -o -name "*.bmp" \)))

if [ ${#WALLPAPERS[@]} -eq 0 ]; then
    echo "Error: No wallpapers found." >>"$LOG_FILE"
    exit 1
fi

RANDOM_WALLPAPER="${WALLPAPERS[$RANDOM % ${#WALLPAPERS[@]}]}"
echo "Selected wallpaper: $RANDOM_WALLPAPER" >>"$LOG_FILE"

TRANSITIONS=("simple" "left" "right" "top" "bottom" "center" "outer" "any" "random")
RANDOM_TRANSITION="${TRANSITIONS[$RANDOM % ${#TRANSITIONS[@]}]}"
echo "Selected transition: $RANDOM_TRANSITION" >>"$LOG_FILE"

/usr/bin/swww img "$RANDOM_WALLPAPER" --transition-type "$RANDOM_TRANSITION"

echo "Finished script." >>"$LOG_FILE"
