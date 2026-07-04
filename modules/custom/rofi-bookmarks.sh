#!/usr/bin/env bash

# Define your bookmarks in a Bash associative array
declare -A bookmarks
bookmarks=(
    ["GitHub"]="https://github.com/pimkoter"
    ["YouTube"]="https://youtube.com"
    ["Proxmox"]="http://192.168.178.10:8006"
)

# Pipe the array keys (the names) into rofi
selection=$(printf "%s\n" "${!bookmarks[@]}" | rofi -dmenu -matching fuzzy -sort -i -p "Bookmarks:")

# If a selection was made and it exists in our array, open the corresponding URL
if [ -n "$selection" ] && [ -n "${bookmarks[$selection]}" ]; then
    xdg-open "${bookmarks[$selection]}"
fi
