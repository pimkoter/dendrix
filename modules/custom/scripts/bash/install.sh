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

# Temporary installation flake
INSTALL_FLAKE="/var/tmp/nixos-install-flake"

# Clean up temporary resources on exit
cleanup() {
    sudo rm -rf "$INSTALL_FLAKE"
}

trap cleanup EXIT


echo "Welcome to the Dendrix installer"
echo

# Discover hosts
mapfile -t HOSTS < <(
    nix --extra-experimental-features 'nix-command flakes' \
        eval --raw "$FLAKE#nixosConfigurations" \
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
echo
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

# Show disk layout
echo "Disk layout:"
echo

nix --extra-experimental-features 'nix-command flakes' \
    eval --raw "$FLAKE#nixosConfigurations.$HOST.config.disko.devices" \
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

if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
    echo "Installation cancelled."
    exit 0
fi

echo
echo "Installing $HOST..."
echo

# Create a root-owned copy of the flake.
#
# nixos-install runs as root, and Nix may reject evaluating a flake
# owned by the normal user. The temporary copy avoids that problem
# without changing ownership of the actual Git repository.
echo "> Preparing flake for installation..."

sudo rm -rf "$INSTALL_FLAKE"
sudo cp -a "$FLAKE" "$INSTALL_FLAKE"
sudo chown -R root:root "$INSTALL_FLAKE"

echo
echo "> Partitioning and mounting disks..."
echo

sudo nix --extra-experimental-features 'nix-command flakes' \
    run github:nix-community/disko/latest -- \
    --flake "$INSTALL_FLAKE#$HOST" \
    --mode destroy,format,mount \
    --yes-wipe-all-disks \
    >/dev/null 2>&1

echo
echo "> Disks set up successfully."
echo

# Find and activate the swap partition created by Disko.
echo "> Activating swap..."

SWAP_DEVICE="$(
    lsblk -nrpo NAME,FSTYPE |
        awk '$2 == "swap" { print $1; exit }'
)"

if [[ -z "$SWAP_DEVICE" ]]; then
    echo "Error: could not find a swap partition."
    exit 1
fi

echo "> Found swap: $SWAP_DEVICE"

sudo swapon "$SWAP_DEVICE"

echo
echo "Active swap:"
swapon --show

echo
echo "Memory available:"
free -h

# Install NixOS.
#
# max-jobs 1 prevents multiple derivations from being built simultaneously.
# cores 1 limits each build to a single CPU core, reducing peak memory use.
echo
echo "> Installing NixOS..."
echo

sudo nixos-install \
    --flake "$INSTALL_FLAKE#$HOST" \
    --option max-jobs 1 \
    --option cores 1

echo
echo "> Installation completed successfully."
echo

read -r -p "Reboot now? [y/N] " REBOOT

if [[ "$REBOOT" =~ ^[Yy][Ee][Ss]$ || "$REBOOT" =~ ^[Yy]$ ]]; then
    sudo reboot
fi
