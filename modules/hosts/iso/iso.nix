{ self, inputs, ... }:

{
  flake.nixosConfigurations.iso = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      ({ pkgs, modulesPath, ... }: {
        imports = [
          "${modulesPath}/installer/cd-dvd/installation-cd-base.nix"
          self.nixosModules.i3
        ];

        isoImage = {
          squashfsCompression = "gzip -Xcompression-level 1";
          contents = [
            {
              source = ../..;
              target = "/etc/dendrix";
            }
          ];
        };

        zramSwap = {
          enable = true;
          algorithm = "zstd";
          memoryPercent = 50;
        };

        environment = {
          systemPackages = with pkgs; [
            neovim # Editor
            tmux # Terminal multiplexer
            git # Git CLI tool
            disko # Declarative partition manager
          ];

          shellAliases = {
            install = "/etc/dendrix/modules/custom/scripts/install.sh";
          };

          interactiveShellInit = "
            ██████╗ ███████╗███╗   ██╗██████╗ ██████╗ ██╗██╗  ██╗
            ██╔══██╗██╔════╝████╗  ██║██╔══██╗██╔══██╗██║╚██╗██╔╝
            ██║  ██║█████╗  ██╔██╗ ██║██║  ██║██████╔╝██║ ╚███╔╝
            ██║  ██║██╔══╝  ██║╚██╗██║██║  ██║██╔══██╗██║ ██╔██╗
            ██████╔╝███████╗██║ ╚████║██████╔╝██║  ██║██║██╔╝ ██╗
            ╚═════╝ ╚══════╝╚═╝  ╚═══╝╚═════╝ ╚═╝  ╚═╝╚═╝╚═╝  ╚═╝
            ";
        };

        users.users.nixos = {
          isNormalUser = true;
          password = "";
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

        nixpkgs = {
          config.allowUnfree = true;
          hostPlatform = "x86_64-linux";
        };
      })
    ];
  };
}
