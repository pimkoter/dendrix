#!/usr/bin/env bash

# Ensure the script exits if a critical background command fails unexpectedly
set -o pipefail

# Helper function to show a standard message box
show_msg() {
  whiptail --title "$1" --msgbox "$2" 10 60
}

# Function to run commands and stream output visually to the user
run_cmd() {
  local title="$1"
  local cmd="$2"

  # Clear screen and run the command so the user can see real-time output
  clear
  echo "=== Running: $title ==="
  echo "Command: $cmd"
  echo "--------------------------------------------------"

  eval "$cmd"
  local status=$?

  echo "--------------------------------------------------"
  if [ $status -eq 0 ]; then
    echo "Success!"
  else
    echo "Failed with exit code $status"
  fi

  read -n 1 -s -r -p "Press any key to return to the menu..."
}

# Main Loop
while true; do
  # Define the main menu options
  CHOICE=$(whiptail --title "NixOS TUI System Manager" \
    --menu "Select an action:" 18 65 8 \
    "1" "List & Switch Generations" \
    "2" "Collect Garbage (Free Space)" \
    "3" "Optimize Nix Store" \
    "4" "Update Flake / Channels" \
    "5" "Rebuild System" \
    "6" "Exit" \
    3>&1 1>&2 2>&3)

  # Exit the loop if the user hits Cancel or Esc
  if [ $? -ne 0 ]; then
    break
  fi

  case "$CHOICE" in
  1)
    # Fetch generations, format them nicely for whiptail
    GENS=$(nixos-rebuild list-generations 2>/dev/null | tail -n +2 | awk '{print $1, $2" "$3}')

    # If generations are found, let the user pick one (basic implementation)
    clear
    echo "=== Current System Generations ==="
    nixos-rebuild list-generations
    echo ""
    read -p "Enter generation number to switch to (or press Enter to go back): " GEN_NUM
    if [ ! -z "$GEN_NUM" ]; then
      run_cmd "Switching to Generation $GEN_NUM" "sudo nixos-rebuild switch --generation $GEN_NUM"
    fi
    ;;
  2)
    run_cmd "Garbage Collection" "nix-collect-garbage -d"
    ;;
  3)
    run_cmd "Optimizing Nix Store" "nix-store --optimize"
    ;;
  4)
    if [ -f "flake.nix" ]; then
      run_cmd "Updating Flake Inputs" "nix flake update"
    else
      run_cmd "Updating Nix Channels" "sudo nix-channel --update"
    fi
    ;;
  5)
    run_cmd "Rebuilding NixOS Configuration" "sudo nixos-rebuild switch"
    ;;
  6)
    break
    ;;
  esac
done

clear
