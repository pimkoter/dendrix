{
  perSystem = { pkgs, ... }: {
    packages.rofi-clipboard = pkgs.writeShellApplication {
      name = "rofi-clipboard";

      runtimeInputs = with pkgs; [
        rofi
        cliphist
        wl-clipboard
        coreutils
        gnugrep
      ];

      text = ''
        set -eu

        entries="$(cliphist list)"

        choice="$(
          {
            echo "🗑 Clear clipboard history"
            printf '%s\n' "$entries" | cut -f2-
          } | rofi \
            -dmenu \
            -p Clipboard
        )"

        [ -n "$choice" ] || exit 0

        if [ "$choice" = "🗑 Clear clipboard history" ]; then
          cliphist wipe
        else
          printf '%s\n' "$entries" |
            grep -F $'\t'"$choice" |
            head -n1 |
            cliphist decode |
            wl-copy
        fi
      '';
    };
  };
}
