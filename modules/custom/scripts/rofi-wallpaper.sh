#!/usr/bin/env bash

# --- CONFIGURATION ---
# Path to your hidden wallpaper directory
WALLPAPER_DIR="$HOME/.wallpapers"

# Supported file extensions
EXTENSIONS="jpg|jpeg|png|webp"
# ---------------------

# Check if the wallpaper directory exists
if [ ! -d "$WALLPAPER_DIR" ]; then
  notify-send "Wallpaper Selector" "Directory $WALLPAPER_DIR does not exist."
  exit 1
fi

# Change to the wallpaper directory
cd "$WALLPAPER_DIR" || exit 1

# Generate the wallpaper list and pipe it DIRECTLY into Rofi.
# Layout: Fixed 3x3 grid, 256px preview size, text hidden completely.
SELECTION=$(find . -type f | grep -E "\.(${EXTENSIONS})$" | sed 's|^\./||' | while read -r file; do
  echo -e "${file}\x00icon\x1f${WALLPAPER_DIR}/${file}"
done | rofi -dmenu -i -p "Select Wallpaper" -show-icons -theme-str '
    window {
        width: 85%;
        height: 85%;
    }
    listview { 
        columns: 6; 
        lines: 5; 
        cycle: true;
        fixed-columns: true;
        fixed-height: false;
        dynamic: true;
        scrollbar: false;
        spacing: 25px;
    } 
    element { 
        orientation: vertical; 
        padding: 10px;
        children: [ element-icon ];
    } 
    element-icon { 
        size: 150px;
        horizontal-align: 0.5;
        vertical-align: 0.5;
    } 
    element-text { 
        display: none; 
    }')

if [ -n "$SELECTION" ]; then
  FULL_PATH="${WALLPAPER_DIR}/${SELECTION}"
  awww img "$FULL_PATH"
  noctalia msg palette-generate "$FULL_PATH"
fi
