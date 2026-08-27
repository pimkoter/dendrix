{
  perSystem = { pkgs, ... }: {

    packages.rofi-repos = pkgs.writeShellApplication {
      name = "rofi-repos";

      runtimeInputs = with pkgs; [
        rofi
        kitty
        tmux
        procps
        coreutils
      ];

      text = ''
        set -eu

        terminal="kitty"
        repo_dir="Repos"

        configs="$(
          find "$HOME/$repo_dir" \
            -mindepth 1 \
            -maxdepth 1 \
            -type d \
            -printf '%f\n' 2>/dev/null
        )"

        [ -n "$configs" ] || exit 0

        chosen="$(
          printf '%s\n' "$configs" |
            rofi -dmenu -i -matching fuzzy -sort -p 'Projects:'
        )"

        [ -n "$chosen" ] || exit 0

        dir="$HOME/$repo_dir/$chosen"

        pkill -x "$terminal" 2>/dev/null || true
        sleep 0.1

        exec "$terminal" -e tmux new-session -As "$chosen" -c "$dir"
      '';
    };
  };
}
