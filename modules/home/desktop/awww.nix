{
  flake.homeModules.awww = { pkgs, lib, ... }: {
    services.awww = {
      enable = true;
    };

    systemd.user.services.awww-init = {
      Unit = {
        Description = "Set a random wallpaper with awww";
        Wants = [ "awww.service" ];
        After = [ "graphical-session.target" ];
      };

      Service = {
        Type = "oneshot";

        ExecStart = pkgs.writeShellScript "awww-init" ''
          set -euo pipefail

          # Wait for awww to become available.
          for _ in $(seq 1 50); do
            if ${lib.getExe pkgs.awww} query >/dev/null 2>&1; then
              break
            fi
            sleep 0.1
          done

          wallpaper="$(
            ${lib.getExe pkgs.fd} \
              --type f \
              --extension jpg \
              --extension jpeg \
              --extension png \
              --extension webp \
              . "$HOME/.wallpapers" |
              ${lib.getExe' pkgs.coreutils "shuf"} -n 1
          )"

          if [ -z "$wallpaper" ]; then
            echo "No wallpapers found in $HOME/.wallpapers" >&2
            exit 1
          fi

          ${lib.getExe pkgs.awww} img "$wallpaper"
        '';
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
