{
  perSystem = { pkgs, ... }: {

    packages.noctalia-bookmarks = pkgs.writeShellApplication {
      name = "noctalia-bookmarks";

      runtimeInputs = with pkgs; [
        noctalia
        xdg-utils
      ];

      text = ''
        declare -A bookmarks

        bookmarks=(
          ["GitHub"]="https://github.com/pimkoter"
          ["YouTube"]="https://youtube.com"
          ["Proxmox"]="http://192.168.178.10:8006"
          ["EE-network"]="https://eenetwork.notion.site/EE-Network-1d7e16c224e140fd825b068cf5f87286#3d3002c47e6d80efb518e02d889872b0"
          ["Brightspace"]="https://brightspace.tudelft.nl/"
          ["Grasple"]="https://app.grasple.com/#/courses"
        )

        selection="$(
          printf "%s\n" "''${!bookmarks[@]}" |
            noctalia dmenu -p "Bookmarks:"
        )"

        if [ -n "$selection" ] && [ -n "''${bookmarks[$selection]:-}" ]; then
          xdg-open "''${bookmarks[$selection]}"
        fi
      '';
    };
  };
}
