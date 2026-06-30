{
  self,
  inputs,
  ...
}: {
  flake.homeModules.zsh = {hostName, ...} @ args: {
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
          tmux
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
        update = "cd ~/.System && git add . && nix flake update && sudo nixos-rebuild switch --flake #${hostName}";
        upgrade = "cd ~/.System && git add . && sudo nixos-rebuild switch  --flake #${hostName}";
        ssn = "sudo systemctl poweroff";
        ssr = "sudo systemctl reboot";
        ff = "fastfetch";
        gens = "sudo nix-env -p /nix/var/nix/profiles/system --list-generations";

        ssh = "kitten ssh";
        tsh = "tailscale ssh";
        shell = "nix-shell -p";

        ls = "eza";
        lt = "eza --tree --level-2";
        ll = "eza -lh --no-user --long";
        la = "eza -lah";
        tree = "eza --tree";
      };
    };
  };
}
