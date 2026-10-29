{
  perSystem = { pkgs, ... }: {
    packages.noctalia-theme = pkgs.writeShellApplication {
      name = "noctalia-theme";

      runtimeInputs = with pkgs; [
        noctalia
        libnotify
      ];

      text = ''
        specs_dir="/run/current-system/specialisation"
        if [ ! -d "$specs_dir" ] && [ -d "/run/booted-system/specialisation" ]; then
          specs_dir="/run/booted-system/specialisation"
        fi

        options=("default")

        if [ -d "$specs_dir" ]; then
          for spec in "$specs_dir"/*; do
            if [ -d "$spec" ]; then
              options+=("$(basename "$spec")")
            fi
          done
        fi

        selected="$(printf '%s\n' "''${options[@]}" | noctalia dmenu -p "Select Theme Specialisation")"

        if [ -n "$selected" ]; then
          if [ "$selected" = "default" ]; then
            notify-send "Theme Switcher" "Switching to default theme..."
            if [ -d "/run/booted-system" ]; then
              sudo /run/booted-system/bin/switch-to-configuration test
            else
              sudo /run/current-system/bin/switch-to-configuration test
            fi
          elif [ -d "/run/current-system/specialisation/$selected" ]; then
            notify-send "Theme Switcher" "Switching to $selected specialisation..."
            sudo "/run/current-system/specialisation/$selected/bin/switch-to-configuration" test
          elif [ -d "/run/booted-system/specialisation/$selected" ]; then
            notify-send "Theme Switcher" "Switching to $selected specialisation..."
            sudo "/run/booted-system/specialisation/$selected/bin/switch-to-configuration" test
          fi
        fi
      '';
    };
  };
}
