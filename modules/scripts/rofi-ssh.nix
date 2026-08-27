{
  perSystem = { pkgs, ... }: {

    packages.rofi-ssh = pkgs.writeShellApplication {
      name = "rofi-ssh";

      runtimeInputs = with pkgs; [
        rofi
        openssh
        gawk
        gnused
        gnugrep
        libnotify
        alacritty
        coreutils
      ];

      text = ''
        config_hosts="$(
          awk '$1 == "Host" {
            for (i = 2; i <= NF; i++)
              print $i
          }' "$HOME/.ssh/config" 2>/dev/null |
          grep -v '^*'
        )"

        known_hosts="$(
          awk '{print $1}' "$HOME/.ssh/known_hosts" 2>/dev/null |
          tr ',' '\n' |
          sed \
            -e 's/\[//g' \
            -e 's/\]:[0-9]*//g' |
          grep -v '^|' |
          sort -u
        )"

        hosts="$(
          printf "%s\n%s\n" "$config_hosts" "$known_hosts" |
            awk NF |
            sort -u
        )"

        if [ -z "$hosts" ]; then
          notify-send \
            "SSH Menu" \
            "No SSH hosts found in config or known_hosts."

          exit 1
        fi

        chosen_host="$(
          printf '%s\n' "$hosts" |
            rofi -dmenu -i -p "SSH Connect:"
        )"

        if [ -n "$chosen_host" ]; then
          alacritty -e ssh "$chosen_host"
        fi
      '';
    };
  };
}
