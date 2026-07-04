#!/usr/bin/env bash

# Get the absolute directory where this script resides
FLAKE_PATH=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

# Define the menu options
OPTIONS="🔄 Rebuild Switch
🧪 Rebuild Test
🚀 Update & Rebuild
📥 Update Flake Lock & Rebuild
🧹 Garbage Collect & Optimize
📋 View Generations"

ROFI_STYLE='
  window { width: 500px; border: 2px; border-radius: 0px; }
  mainbox { children: [ inputbar, listview ]; }
  listview { layout: vertical; spacing: 8px; padding: 10px; columns: 1; lines: 6; dynamic: true; fixed-height: false; }
  element { padding: 12px; border: 1px; border-radius: 0px; children: [ element-text ]; }
  element-text { vertical-align: 0.5; }
'

CHOICE=$(echo "$OPTIONS" | rofi -dmenu -matching fuzzy -i -p "Select option: " -theme-str "$ROFI_STYLE")

# Terminal executor syntax for Kitty
TERM_EXEC="kitty -- sh -c"

case "$CHOICE" in
    "🧪 Rebuild Test")
        $TERM_EXEC "echo 'Executing: nixos-rebuild test --flake ${FLAKE_PATH}' && sudo nixos-rebuild test --flake ${FLAKE_PATH} && read -p 'Press enter to exit...'"
        ;;
    "🔄 Rebuild Switch")
        $TERM_EXEC "echo 'Executing: nixos-rebuild switch --flake ${FLAKE_PATH}' && sudo nixos-rebuild switch --flake ${FLAKE_PATH} && read -p 'Press enter to exit...'"
        ;;
    "🚀 Update Flake Lock & Rebuild")
        $TERM_EXEC "echo 'Updating flake locks in ${FLAKE_PATH}...' && cd ${FLAKE_PATH} && nix flake update && echo 'Rebuilding...' && sudo nixos-rebuild switch --flake ${FLAKE_PATH} && read -p 'Press enter to exit...'"
        ;;
    "🧹 Garbage Collect & Optimize")
        $TERM_EXEC "echo 'Collecting garbage and optimizing store...' && sudo nix-env --delete-generations old && sudo nix-store --gc && nix-store --optimize && read -p 'Press enter to exit...'"
        ;;
    "📋 View Generations")
        $TERM_EXEC "nix-env --profile /nix/var/nix/profiles/system --list-generations && read -p 'Press enter to exit...'"
        ;;
    *)
        exit 0
        ;;
esac
