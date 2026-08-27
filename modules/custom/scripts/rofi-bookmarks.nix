{
  perSystem = { pkgs, ... }: {

    packages.rofi-bookmarks = pkgs.writeShellApplication {
      name = "rofi-bookmarks";

      runtimeInputs = with pkgs; [
        rofi
        xdg-utils
      ];

      text = ''
        declare -A bookmarks

        bookmarks=(
          ["GitHub"]="https://github.com/pimkoter"
          ["YouTube"]="https://youtube.com"
          ["Proxmox"]="http://192.168.178.10:8006"
        )

        selection="$(
          printf "%s\n" "''${!bookmarks[@]}" |
            rofi -dmenu -matching fuzzy -sort -i -p "Bookmarks:"
        )"

        if [ -n "$selection" ] && [ -n "''${bookmarks[$selection]:-}" ]; then
          xdg-open "''${bookmarks[$selection]}"
        fi
      '';
    };
  };
}
