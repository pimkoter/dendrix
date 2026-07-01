{
  self,
  inputs,
  ...
}: {
  flake.homeModules.zsh = {
    programs.zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting = {
        enable = true;
        highlighters = [
          "main"
          "brackets"
          "pattern"
          "regexp"
          "root"
          "line"
        ];
      };
      historySubstringSearch.enable = true;

      initContent = ''
        if [[ $- == *i* ]]; then
          if [ -z "$TMUX" ]; then
            tmux
          fi
          fastfetch
        fi
      '';

      shellAliases = {
        sv = "sudo nvim";
        v = "nvim";
        ncg = "nix-collect-garbage --delete-old && sudo nix-collect-garbage -d && sudo /run/current-system/bin/switch-to-configuration boot";
        cat = "bat";
        c = "clear";
        e = "exit";
        bottom = "btm";
        ssn = "sudo systemctl poweroff";
        srn = "sudo systemctl reboot";
        ff = "fastfetch";
        gens = "sudo nix-env -p /nix/var/nix/profiles/system --list-generations";

        ssh = "kitten ssh";
        tsh = "tailscale ssh";
        shell = "nix-shell -p";

        ls = "eza";
        ll = "eza -lh --no-user --long";
        la = "eza -lah";
        tree = "eza --tree";
      };
    };
  };
}
