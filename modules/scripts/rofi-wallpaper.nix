{
  perSystem = { pkgs, ... }: {

    packages.rofi-wallpaper = pkgs.writeShellApplication {
      name = "rofi-wallpaper";

      runtimeInputs = with pkgs; [
        rofi
        findutils
        gnugrep
        gnused
        libnotify
        awww
        noctalia
      ];

      text = ''
        wallpaper_dir="$HOME/.wallpapers"
        extensions="jpg|jpeg|png|webp"

        if [ ! -d "$wallpaper_dir" ]; then
          notify-send \
            "Wallpaper Selector" \
            "Directory $wallpaper_dir does not exist."

          exit 1
        fi

        cd "$wallpaper_dir"

        selection="$(
          find . -type f |
            grep -E "\.($extensions)$" |
            sed 's|^\./||' |
            while read -r file; do
              echo -e "''${file}\x00icon\x1f''${wallpaper_dir}/''${file}"
            done |
            rofi \
              -dmenu \
              -i \
              -p "Select Wallpaper" \
              -show-icons \
              -theme-str '
                window {
                    width: 85%;
                    height: 85%;
                }

                listview {
                    columns: 6;
                    lines: 5;
                    cycle: true;
                    fixed-columns: true;
                    fixed-height: false;
                    dynamic: true;
                    scrollbar: false;
                    spacing: 25px;
                }

                element {
                    orientation: vertical;
                    padding: 10px;
                    children: [ element-icon ];
                }

                element-icon {
                    size: 150px;
                    horizontal-align: 0.5;
                    vertical-align: 0.5;
                }

                element-text {
                    display: none;
                }
              '
        )"

        if [ -n "$selection" ]; then
          full_path="''${wallpaper_dir}/''${selection}"

          awww img "$full_path"
          noctalia msg palette-generate "$full_path"
        fi
      '';
    };
  };
}
