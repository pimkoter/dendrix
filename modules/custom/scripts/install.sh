#!/usr/bin/env bash
set -euo pipefail

# --- Color Formatting ---
BOLD='\033[1m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BOLD}${BLUE}===========================================${NC}"
echo -e "${BOLD}${BLUE}       Dendrix NixOS Installer Tool        ${NC}"
echo -e "${BOLD}${BLUE}===========================================${NC}\n"

# 1. Root Check
if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}Error: Please run this script with root privileges (sudo ./install.sh)${NC}"
  exit 1
fi

FLAKE_DIR="/etc/dendrix"

# Fall back to local directory if script is run outside the baked ISO path
if [ ! -d "$FLAKE_DIR" ]; then
  FLAKE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
fi

echo -e "${GREEN}--> Using Flake configuration from:${NC} $FLAKE_DIR"

# 2. Select Target Host Configuration
HOSTS=($(ls -d $FLAKE_DIR/modules/hosts/*/ | xargs -n 1 basename | grep -v 'iso'))

if [ ${#HOSTS[@]} -eq 0 ]; then
  echo -e "${RED}No host configurations found in modules/hosts/!${NC}"
  exit 1
fi

echo -e "\n${BOLD}Available host configurations:${NC}"
select HOST in "${HOSTS[@]}"; do
  if [ -n "$HOST" ]; then
    echo -e "${GREEN}Selected host:${NC} ${BOLD}$HOST${NC}"
    break
  else
    echo -e "${RED}Invalid selection. Try again.${NC}"
  fi
done

# 3. Partitioning Strategy Selection
DISKO_CONFIG="$FLAKE_DIR/modules/hosts/$HOST/disk-config.nix"

echo -e "\n${BOLD}Select Partitioning Method:${NC}"
echo "1) Automated (Disko - format drives according to disk-config.nix)"
echo "2) Manual (Skip formatting, assume drives are already mounted under /mnt)"

read -rp "Choice [1-2]: " PART_CHOICE

case $PART_CHOICE in
1)
  if [ ! -f "$DISKO_CONFIG" ]; then
    echo -e "${RED}Error: Disko config not found at $DISKO_CONFIG${NC}"
    exit 1
  fi
  echo -e "${YELLOW}WARNING: Disko will format your target drive(s) and wipe all existing data!${NC}"
  read -rp "Are you sure you want to proceed? [y/N]: " CONFIRM
  if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
    echo -e "${RED}Installation aborted.${NC}"
    exit 0
  fi
  echo -e "${GREEN}--> Running Disko partitioning...${NC}"
  nix --extra-experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko "$DISKO_CONFIG"
  ;;
2)
  echo -e "${GREEN}--> Skipping Disko formatting.${NC}"
  if ! mountpoint -q /mnt; then
    echo -e "${RED}Error: /mnt is not mounted. Please mount your root target partition to /mnt manually.${NC}"
    exit 1
  fi
  ;;
*)
  echo -e "${RED}Invalid choice. Aborting.${NC}"
  exit 1
  ;;
esac

# 4. Generate Hardware Configuration (if missing)
TARGET_HW_CONFIG="$FLAKE_DIR/modules/hosts/$HOST/hardware-configuration.nix"

if [ ! -f "$TARGET_HW_CONFIG" ]; then
  echo -e "${YELLOW}--> $TARGET_HW_CONFIG missing. Generating hardware configuration from live detection...${NC}"
  nixos-generate-config --root /mnt --show-hardware-config >"$TARGET_HW_CONFIG"
  echo -e "${GREEN}--> Hardware config written to $TARGET_HW_CONFIG${NC}"
fi

# 5. Optional Secrets Key Copying (age / sops)
echo -e "\n${BOLD}Secrets Management (sops/age):${NC}"
read -rp "Do you need to copy an age/sops key to the new host before building? [y/N]: " COPY_KEY
if [[ "$COPY_KEY" =~ ^[Yy]$ ]]; then
  read -rp "Enter source path to your key file (e.g. /media/usb/keys.txt): " KEY_SRC
  if [ -f "$KEY_SRC" ]; then
    mkdir -p /mnt/var/lib/sops-nix/ /mnt/root/.config/sops/age/
    cp "$KEY_SRC" /mnt/var/lib/sops-nix/key.txt
    cp "$KEY_SRC" /mnt/root/.config/sops/age/keys.txt
    chmod 600 /mnt/var/lib/sops-nix/key.txt
    echo -e "${GREEN}--> Secret keys imported successfully.${NC}"
  else
    echo -e "${RED}File $KEY_SRC not found. Skipping key copy...${NC}"
  fi
fi

# 6. Execute Installation
echo -e "\n${BOLD}${GREEN}===========================================${NC}"
echo -e "${BOLD}${GREEN}    Starting NixOS Installation for $HOST  ${NC}"
echo -e "${BOLD}${GREEN}===========================================${NC}\n"

nixos-install --flake "$FLAKE_DIR#$HOST"

# 7. Post-install prompt
echo -e "\n${BOLD}${GREEN}Installation Complete!${NC}"
read -rp "Would you like to reboot into your new system now? [y/N]: " REBOOT_CHOICE
if [[ "$REBOOT_CHOICE" =~ ^[Yy]$ ]]; then
  reboot
fi
