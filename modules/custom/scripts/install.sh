
#!/usr/bin/env bash

set -euo pipefail

# ─────────────────────────────────────────────────────────────

# DENDRIX INSTALLER

# ─────────────────────────────────────────────────────────────

FLAKE="$(git -C "$(dirname -- "${BASH_SOURCE[0]}")" rev-parse --show-toplevel)"

export NIX_CONFIG="experimental-features = nix-command flakes"

# ─────────────────────────────────────────────────────────────

# Helpers

# ─────────────────────────────────────────────────────────────

die() {
echo
echo "Error: $*" >&2
exit 1
}

pause() {
read -rp "Press Enter to continue..."
}

# ─────────────────────────────────────────────────────────────

# Root check

# ─────────────────────────────────────────────────────────────

if [[ $EUID -ne 0 ]]; then
exec sudo -- "$0" "$@"
fi

# ─────────────────────────────────────────────────────────────

# Splash

# ─────────────────────────────────────────────────────────────

clear

cat <<'EOF'
╔══════════════════════════════════════════════════════════════╗
║                                                              ║
║                     DENDRIX INSTALLER                        ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝
EOF

echo

[[ -f "$FLAKE/flake.nix" ]] ||
die "Could not find flake.nix in $FLAKE"

echo "Flake:"
echo "  $FLAKE"
echo

# ─────────────────────────────────────────────────────────────

# Discover hosts

# ─────────────────────────────────────────────────────────────

echo "Discovering available hosts..."
echo

mapfile -t HOSTS < <(
    nix eval --impure --raw \
        --expr "
          let
            flake = builtins.getFlake \"$FLAKE\";
          in
            builtins.concatStringsSep \"\\n\"
              (builtins.attrNames flake.nixosConfigurations)
        "
)

if [[ ${#HOSTS[@]} -eq 0 ]]; then
    echo
    echo "Error: No nixosConfigurations found in the flake."
    exit 1
fi

echo "Available hosts:"
echo

for i in "${!HOSTS[@]}"; do
    printf "  %d) %s\n" "$((i + 1))" "${HOSTS[$i]}"
done

echo

while true; do
    read -rp "Select a host [1-${#HOSTS[@]}]: " SELECTION

    if [[ "$SELECTION" =~ ^[0-9]+$ ]] &&
       (( SELECTION >= 1 && SELECTION <= ${#HOSTS[@]} )); then
        break
    fi

    echo "Invalid selection."
done

HOST="${HOSTS[$((SELECTION - 1))]}"

# ─────────────────────────────────────────────────────────────

# Host selection

# ─────────────────────────────────────────────────────────────

while true; do
read -rp "Select a host [1-${#HOSTS[@]}]: " SELECTION

```
if [[ "$SELECTION" =~ ^[0-9]+$ ]] &&
   (( SELECTION >= 1 && SELECTION <= ${#HOSTS[@]} )); then
    break
fi

echo "Invalid selection."
```

done

HOST="${HOSTS[$((SELECTION - 1))]}"

# ─────────────────────────────────────────────────────────────

# Validate configuration

# ─────────────────────────────────────────────────────────────

echo
echo "Selected host:"
echo
echo "  $HOST"
echo

echo "Validating NixOS configuration..."

nix eval 
"$FLAKE#nixosConfigurations.$HOST.config.system.build.toplevel.drvPath" 
>/dev/null ||
die "The NixOS configuration '$HOST' could not be evaluated."

# ─────────────────────────────────────────────────────────────

# Show Disko configuration

# ─────────────────────────────────────────────────────────────

echo
echo "Disk configuration:"
echo

DISKO_DEVICES="$(
nix eval 
--json 
"$FLAKE#nixosConfigurations.$HOST.config.disko.devices.disk" 
2>/dev/null || echo '{}'
)"

if [[ "$DISKO_DEVICES" == "{}" ]]; then
echo "  No Disko configuration found."
echo
echo "This installer expects the selected host to provide"
echo "a disko.devices configuration."
exit 1
fi

echo "$DISKO_DEVICES" |
jq -r '
to_entries[] |
"  (.key): (.value.device)"
'

echo

# ─────────────────────────────────────────────────────────────

# Confirmation

# ─────────────────────────────────────────────────────────────

cat <<EOF

╔══════════════════════════════════════════════════════════════╗
║                         WARNING                              ║
╚══════════════════════════════════════════════════════════════╝

Host:

$HOST

The disks listed above will be partitioned and formatted
according to the Disko configuration of this host.

Existing data on those disks may be DESTROYED.

EOF

read -rp "Continue with installation? [y/N]: " CONFIRM

if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
echo
echo "Installation cancelled."
exit 0
fi

# ─────────────────────────────────────────────────────────────

# Run Disko

# ─────────────────────────────────────────────────────────────

clear

cat <<EOF
╔══════════════════════════════════════════════════════════════╗
║                     DENDRIX INSTALLER                        ║
╚══════════════════════════════════════════════════════════════╝

Installing:

$HOST

EOF

echo "==> Running Disko..."

nix run github:nix-community/disko/latest -- 
--mode disko 
--flake "$FLAKE#$HOST"

# ─────────────────────────────────────────────────────────────

# Generate hardware configuration

# ─────────────────────────────────────────────────────────────

echo
echo "==> Generating hardware configuration..."

nixos-generate-config 
--root /mnt

# ─────────────────────────────────────────────────────────────

# Install NixOS

# ─────────────────────────────────────────────────────────────

echo
echo "==> Installing NixOS..."

nixos-install 
--root /mnt 
--flake "$FLAKE#$HOST"

# ─────────────────────────────────────────────────────────────

# Done

# ─────────────────────────────────────────────────────────────

clear

cat <<EOF
╔══════════════════════════════════════════════════════════════╗
║                                                              ║
║                 INSTALLATION COMPLETE                        ║
║                                                              ║
║  Host: $HOST
║                                                              ║
╚══════════════════════════════════════════════════════════════╝
EOF

echo
echo "The system has been installed successfully."
echo

read -rp "Reboot now? [y/N]: " REBOOT

if [[ "$REBOOT" =~ ^[Yy]$ ]]; then
reboot
fi
