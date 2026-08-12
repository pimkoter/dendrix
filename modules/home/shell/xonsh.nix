{
  flake.homeModules.xonsh =
    { pkgs, lib, ... }:

    let
      aliases = {
        cd = "z";
        cdi = "zi";

        v = "nvim";
        V = "sudo nvim";

        cat = "bat";
        find = "fd";
        lg = "lazygit";

        c = "clear";
        e = "exit";

        ssn = "sudo systemctl poweroff";
        srn = "sudo systemctl reboot";

        ff = "fastfetch";

        shell = "nix-shell -p";
        nd = "nix develop --impure -c xonsh";
        gens = "sudo nixos-rebuild list-generations";

        ls = "eza";
        ll = "eza -lh --no-user --long";
        la = "eza -lah --no-git";
        tree = "eza --no-git --tree";
      };

      aliasLines = lib.concatStringsSep "\n" (
        lib.mapAttrsToList (
          name: command: "aliases[${builtins.toJSON name}] = ${builtins.toJSON command}"
        ) aliases
      );
    in
    {
      home.packages = [
        pkgs.xonsh
      ];

      home.file.".xonshrc".text = ''
        # Init
        execx($(starship init xonsh))

        # Interactive startup
        if $XONSH_INTERACTIVE:
            if not __xonsh__.env.get("TMUX"):
                import os
                os.execvp("tmux", ["tmux"])

            fastfetch

        $XONSH_SHOW_TRACEBACK = True

        # Aliases
        ${aliasLines}

        # Zoxide
        execx($(zoxide init xonsh), 'exec', __xonsh__.ctx, filename='zoxide')
      '';
    };
}
