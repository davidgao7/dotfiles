#!/bin/bash

# Define the directory where your wallpapers are stored
WALLPAPER_DIR="$HOME/anime/"

# Find all image files in the directory
WALLPAPERS=($(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.gif" -o -name "*.svg" -o -name "*.webp" -o -name "*.bmp" \)))

# Check if any wallpapers were found
if [ ${#WALLPAPERS[@]} -eq 0 ]; then
    echo "No wallpapers found in $WALLPAPER_DIR"
    exit 1
fi

# Select a random wallpaper from the array
RANDOM_WALLPAPER="${WALLPAPERS[$RANDOM % ${#WALLPAPERS[@]}]}"

# Define the available transition types
TRANSITIONS=("simple" "left" "right" "top" "bottom" "center" "outer" "any" "random")

# Select a random transition type
RANDOM_TRANSITION="${TRANSITIONS[$RANDOM % ${#TRANSITIONS[@]}]}"

# Set the wallpaper with a random transition type using swww
swww img "$RANDOM_WALLPAPER" --resize="fit" --transition-type "$RANDOM_TRANSITION"

echo "Changed wallpaper to $RANDOM_WALLPAPER with transition type: $RANDOM_TRANSITION"
