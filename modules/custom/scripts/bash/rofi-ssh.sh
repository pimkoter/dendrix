#!/usr/bin/env bash

# Gather hosts from ~/.ssh/config
config_hosts=$(awk '$1 == "Host" {for (i=2; i<=NF; i++) print $i}' ~/.ssh/config 2>/dev/null | grep -v '^*')

# Gather hosts from ~/.ssh/known_hosts (stripping ports, hashes, and salt)
known_hosts=$(awk '{print $1}' ~/.ssh/known_hosts 2>/dev/null | tr ',' '\n' | sed -e 's/\[//g' -e 's/\]:[0-9]*//g' | grep -v '^|' | sort -u)

# Combine, deduplicate, and filter out wildcards/empty lines
hosts=$(printf "%s\n%s\n" "$config_hosts" "$known_hosts" | awk NF | sort -u)

# Check if any hosts were found
if [ -z "$hosts" ]; then
  notify-send "SSH Menu" "No SSH hosts found in config or known_hosts."
  exit 1
fi

# Prompt user via Rofi
chosen_host=$(echo "$hosts" | rofi -dmenu -i -p "SSH Connect:")

# If a host was selected, open it in your terminal
if [ -n "$chosen_host" ]; then
  # Change 'alacritty -e' to your preferred terminal emulator (e.g., kitty -e, foot, gnome-terminal --)
  alacritty -e ssh "$chosen_host"
fi
