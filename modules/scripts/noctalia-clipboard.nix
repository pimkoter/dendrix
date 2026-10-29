{
  perSystem = { pkgs, ... }: {
    packages.noctalia-clipboard = pkgs.writeShellApplication {
      name = "noctalia-clipboard";

      runtimeInputs = with pkgs; [
        noctalia
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
          } | noctalia dmenu \
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
