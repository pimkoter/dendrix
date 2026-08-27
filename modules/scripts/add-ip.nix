{
  perSystem = { pkgs, ... }: {
    packages.add-ip = pkgs.writeShellApplication {
      name = "add-ip";

      runtimeInputs = with pkgs; [
        iproute2
        gawk
        coreutils
        sudo
      ];

      text = ''
        default_iface="$(
          ip route show default 2>/dev/null |
            awk '/default/ {print $5}' |
            head -n 1
        )"

        read -r -p "What IP address would you like to add? " address
        read -r -p "Which network interface? [default: ''${default_iface}]: " iface

        iface="''${iface:-$default_iface}"

        if [ -z "$iface" ]; then
          echo "Error: Could not automatically detect a network interface, and none was provided."
          exit 1
        fi

        sudo ip addr add "$address" dev "$iface"

        echo "Added IP $address to interface $iface"
      '';
    };
  };
}
