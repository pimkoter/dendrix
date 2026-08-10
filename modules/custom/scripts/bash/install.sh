#!/usr/bin/env bash

set -euo pipefail

# Discover flake location
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

FLAKE="$SCRIPT_DIR"

while [[ "$FLAKE" != "/" && ! -f "$FLAKE/flake.nix" ]]; do
    FLAKE="$(dirname "$FLAKE")"
done

if [[ ! -f "$FLAKE/flake.nix" ]]; then
    echo "Error: could not find flake.nix."
    exit 1
fi

# Discover hosts
mapfile -t HOSTS < <(
    nix --extra-experimental-features 'nix-command flakes' eval --raw "$FLAKE#nixosConfigurations" \
        --apply 'x: builtins.concatStringsSep "\n" (builtins.attrNames x)' \
        </dev/null
)

if (( ${#HOSTS[@]} == 0 )); then
    echo "Error: no NixOS hosts found."
    exit 1
fi

# Select host
for i in "${!HOSTS[@]}"; do
    printf '%d. %s\n' "$((i + 1))" "${HOSTS[$i]}"
done

echo
printf 'Select a host: '
read -r CHOICE

if [[ ! "$CHOICE" =~ ^[0-9]+$ ]] ||
   (( CHOICE < 1 || CHOICE > ${#HOSTS[@]} )); then
    echo "Invalid selection."
    exit 1
fi

HOST="${HOSTS[$((CHOICE - 1))]}"

echo
echo "Selected host: $HOST"
echo 

echo
echo "Disk layout:"
echo

nix --extra-experimental-features 'nix-command flakes' eval --raw "$FLAKE#nixosConfigurations.$HOST.config.disko.devices" \
    --apply '
      devices:
      let
        formatPartition = disk: name: last:
          let
            partition = disk.content.partitions.${name};
            content = partition.content;
            format = content.format or content.type;
            mountpoint = content.mountpoint or "";
            prefix = if last then "  └─" else "  ├─";
            suffix = if mountpoint == "" then "" else "  ${mountpoint}";
          in
            "${prefix} ${name}  ${partition.size}  ${format}${suffix}";

        formatDisk = name:
          let
            disk = devices.disk.${name};
            partitions = builtins.attrNames disk.content.partitions;
            count = builtins.length partitions;
          in
            "  ${disk.device}\n"
            + "  ├─ ${disk.content.type}\n"
            + builtins.concatStringsSep "\n"
              (builtins.genList
                (i:
                  formatPartition
                    disk
                    (builtins.elemAt partitions i)
                    (i == count - 1))
                count);
      in
        builtins.concatStringsSep "\n\n"
          (builtins.map formatDisk (builtins.attrNames devices.disk))
    '

echo
echo
read -r -p "Continue with installation? [y/N] " CONFIRM

[[ "$CONFIRM" =~ ^[Yy]$ ]] || exit 0

if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
    echo "Installation cancelled."
    exit 0
fi

echo
echo "Installing $HOST..."
echo
# Partition, format and mount
echo
echo "Partitioning and mounting disks..."

if ! sudo disko \
    --flake "$FLAKE#$HOST" \
    --mode destroy,format,mount \
    --yes-wipe-all-disks \
    >/dev/null 2>&1; then
    echo "Error: Disko failed."
    exit 1
fi

echo "Disks set up successfully."
echo

# Install NixOS
echo "Installing NixOS..."
echo

if ! sudo nixos-install --flake "$FLAKE#$HOST"; then
    echo "Error: NixOS installation failed."
    exit 1
fi

echo
echo "Installation completed successfully."

read -r -p "Reboot now? [y/N] " REBOOT

if [[ "$REBOOT" =~ ^[Yy][Ee][Ss]$ || "$REBOOT" =~ ^[Yy]$ ]]; then
    sudo reboot
fi
