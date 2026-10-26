{
  perSystem = { pkgs, ... }: {

    packages.noctalia-repos = pkgs.writeShellApplication {
      name = "noctalia-repos";

      runtimeInputs = with pkgs; [
        noctalia
        kitty
        herdr
        coreutils
        findutils
      ];

      text = ''
        set -eu
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
            noctalia dmenu -p 'Projects:'
        )"

        [ -n "$chosen" ] || exit 0

        dir="$HOME/$repo_dir/$chosen"

        exec herdr workspace create --focus --cwd "$dir" --label "$chosen"
      '';
    };
  };
}
