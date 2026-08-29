{
  perSystem = { pkgs, ... }: {
    packages.dendrix-install = pkgs.writeShellApplication {
      name = "dendrix-install";

      runtimeInputs = with pkgs; [
        networkmanager
        nix
        nixos-install-tools
        disko
        coreutils
        gawk
        util-linux
        sudo
        jq
        git
      ];

      text = ''
        set -euo pipefail

        # --------------------------------------------------------------------
        # Network setup.
        # --------------------------------------------------------------------

        nmtui

        echo
        echo '██████╗ ███████╗███╗   ██╗██████╗ ██████╗ ██╗██╗  ██╗'
        echo '██╔══██╗██╔════╝████╗  ██║██╔══██╗██╔══██╗██║╚██╗██╔╝'
        echo '██║  ██║█████╗  ██╔██╗ ██║██║  ██║██████╔╝██║ ╚███╔╝'
        echo '██║  ██║██╔══╝  ██║╚██╗██║██║  ██║██╔══██╗██║ ██╔██╗'
        echo '██████╔╝███████╗██║ ╚████║██████╔╝██║  ██║██║██╔╝ ██╗'
        echo '╚═════╝ ╚══════╝╚═╝  ╚═══╝╚═════╝ ╚═╝  ╚═╝╚═╝╚═╝  ╚═╝'

        echo
        echo "Welcome to the Dendrix installer."
        echo

        # --------------------------------------------------------------------
        # Obtain the flake.
        #
        # Use the supplied path or search upward from the current directory.
        # If no path is supplied, clone the Dendrix repository.
        # --------------------------------------------------------------------

        INSTALL_FLAKE="/var/tmp/nixos-install-flake"

        cleanup() {
          sudo rm -rf "$INSTALL_FLAKE"
        }

        trap cleanup EXIT

        sudo rm -rf "$INSTALL_FLAKE"

        if [[ -n "''${1:-}" ]]; then
          FLAKE="$1"

          while [[ "$FLAKE" != "/" && ! -f "$FLAKE/flake.nix" ]]; do
            FLAKE="$(dirname "$FLAKE")"
          done

          if [[ ! -f "$FLAKE/flake.nix" ]]; then
            echo "Error: could not find flake.nix."
            exit 1
          fi

          echo "> Using flake: $FLAKE"

          sudo cp -a "$FLAKE" "$INSTALL_FLAKE"
        else
          echo "> Cloning Dendrix..."

          git clone \
            https://github.com/pimkoter/dendrix \
            "$INSTALL_FLAKE"
        fi

        sudo chown -R root:root "$INSTALL_FLAKE"

        FLAKE="$INSTALL_FLAKE"

        echo "> Using installation flake: $FLAKE"
        echo

        # --------------------------------------------------------------------
        # Find available NixOS hosts.
        # --------------------------------------------------------------------

        echo "Available NixOS hosts:"
        echo

        mapfile -t HOSTS < <(
          nix --extra-experimental-features 'nix-command flakes' \
            eval --json "$FLAKE#nixosConfigurations" |
            jq -r 'keys[]' |
            sort
        )

        if (( ''${#HOSTS[@]} == 0 )); then
          echo "Error: no NixOS hosts found."
          exit 1
        fi

        for i in "''${!HOSTS[@]}"; do
          printf '%d. %s\n' "$((i + 1))" "''${HOSTS[$i]}"
        done

        echo
        printf 'Select a host: '
        read -r CHOICE

        if [[ ! "$CHOICE" =~ ^[0-9]+$ ]] ||
          (( CHOICE < 1 || CHOICE > ''${#HOSTS[@]} )); then
          echo "Invalid selection."
          exit 1
        fi

        HOST="''${HOSTS[$((CHOICE - 1))]}"

        echo
        echo "Selected host: $HOST"
        echo

        # --------------------------------------------------------------------
        # Verify that the host has a Disko configuration.
        # --------------------------------------------------------------------

        if ! nix --extra-experimental-features 'nix-command flakes' \
          eval "$FLAKE#nixosConfigurations.$HOST.config.disko.devices" \
          >/dev/null 2>&1; then
          echo "Error: host '$HOST' does not have a valid Disko configuration."
          exit 1
        fi

        # --------------------------------------------------------------------
        # Display disk layout.
        #
        # The Nix expression is passed as an argument to nix rather than
        # embedded into the shell command itself.
        # --------------------------------------------------------------------

        DISK_LAYOUT_EXPR='
          devices:
          let
            formatPartition = disk: name: last:
              let
                partition = builtins.getAttr name disk.content.partitions;
                content = partition.content;
                format = content.format or content.type;
                mountpoint = content.mountpoint or "";
                prefix = if last then "  └─" else "  ├─";
                suffix =
                  if mountpoint == ""
                  then ""
                  else "  " + mountpoint;
              in
                prefix
                + " "
                + name
                + "  "
                + partition.size
                + "  "
                + format
                + suffix;

            formatDisk = name:
              let
                disk = builtins.getAttr name devices.disk;
                partitions = builtins.attrNames disk.content.partitions;
                count = builtins.length partitions;
              in
                "  "
                + disk.device
                + "\n"
                + "  ├─ "
                + disk.content.type
                + "\n"
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

        echo "Disk layout:"
        echo

        nix --extra-experimental-features 'nix-command flakes' \
          eval --raw \
          "$FLAKE#nixosConfigurations.$HOST.config.disko.devices" \
          --apply "$DISK_LAYOUT_EXPR"

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

        # --------------------------------------------------------------------
        # Partition and mount disks.
        # --------------------------------------------------------------------

        echo "> Partitioning and mounting disks..."

        sudo disko \
          --flake "$FLAKE#$HOST" \
          --mode destroy,format,mount \
          --yes-wipe-all-disks

        echo
        echo "> Disks set up successfully."

        # --------------------------------------------------------------------
        # Activate swap.
        # --------------------------------------------------------------------

        echo
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

        # --------------------------------------------------------------------
        # Install NixOS.
        # --------------------------------------------------------------------

        echo
        echo "> Installing NixOS..."
        echo

        sudo nixos-install \
          --flake "$FLAKE#$HOST"

        echo
        echo "> Installation completed successfully."
        echo

        # --------------------------------------------------------------------
        # Reboot.
        # --------------------------------------------------------------------

        read -r -p "Reboot now? [y/N] " REBOOT

        if [[ "$REBOOT" =~ ^[Yy]([Ee][Ss])?$ ]]; then
          sudo reboot
        fi
      '';
    };
  };
}
