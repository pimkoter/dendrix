{ self, inputs, ... }:

{
  flake.nixosConfigurations.iso = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      ({ pkgs, modulesPath, ... }: {
        imports = [
          "${modulesPath}/installer/cd-dvd/installation-cd-base.nix"
          self.nixosModules.i3
        ];

        environment = {
          systemPackages =
            (with pkgs; [
              neovim # Editor
              tmux # Terminal multiplexer
              git # Git CLI tool
              disko # Declarative partition manager
              ripgrep # Better grep

            ])
            ++ [
              self.packages.${pkgs.stdenv.hostPlatform.system}.dendrix-install
            ];
        };

        programs.bash.interactiveShellInit = ''
           if [[ -z "''$TMUX" ]]; then
             exec ${pkgs.tmux}/bin/tmux
           fi

          dendrix-install
        '';

        users.users.nixos = {
          isNormalUser = true;
          password = null;
          extraGroups = [
            "wheel"
            "networkmanager"
          ];
        };

        systemd.targets = {
          sleep.enable = false;
          suspend.enable = false;
          hibernate.enable = false;
          hybrid-sleep.enable = false;
        };

        nix.settings.experimental-features = [
          "nix-command"
          "flakes"
        ];

        nixpkgs = {
          config.allowUnfree = true;
          hostPlatform = "x86_64-linux";
        };
      })
    ];
  };
}
