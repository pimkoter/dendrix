{
  flake.homeModules.bash = {
    programs.bash = {
      enable = true;

      shellAliases = {
        cd = "z";
        cdi = "zi";
        cg = "cd \"$(git rev-parse --show-toplevel 2>/dev/null)\"";

        v = "nvim";
        V = "sudo nvim";

        cat = "bat";
        find = "fd";
        lg = "lazygit";

        c = "clear";
        e = "exit";

        ssn = "sudo systemctl poweroff";
        srn = "sudo systemctl reboot";

        ff = "clear && fastfetch";

        shell = "nix-shell -p";
        nd = "nix develop";
        gens = "sudo nixos-rebuild list-generations";

        ls = "eza";
        ll = "eza -lh --no-user --long";
        la = "eza -lah --no-git";
        tree = "eza --no-git --tree";
      };

      initExtra = ''
        # Starship
        eval "$(starship init bash)"

        # Zoxide
        eval "$(zoxide init bash)"

        # Launch Herdr for interactive shells.
        if [[ $- == *i* && -z "$HERDR_ENV" ]]; then
          exec herdr
        fi

        fastfetch
      '';
    };
  };
}
