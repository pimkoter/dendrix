{ inputs, ... }:

{
  flake.nixosConfigurations.iso = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      ({ pkgs, modulesPath, ... }: {
        imports = [
          "${modulesPath}/installer/cd-dvd/installation-cd-base.nix"
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

          interactiveShellInit = ''
            echo ""
            echo -e "\e[1;35m  ____                  _     _ \e[0m"
            echo -e "\e[1;35m |  _ \  ___ _ __  _ __| |_ _| |\e[0m"
            echo -e "\e[1;35m | | | |/ _ \ '_ \| '__| __/ _\` |\e[0m"
            echo -e "\e[1;35m | |_| |  __/ | | | |  | || (_| |\e[0m"
            echo -e "\e[1;35m |____/ \___|_| |_|_|   \__\__,_|\e[0m"
            echo ""
            echo -e "\e[1;32mWelcome to your custom Dendrix NixOS Live Environment!\e[0m"
            echo ""
            echo -e "\e[1;34mUseful Commands:\e[0m"
            echo -e "  \e[33minstall\e[0m       - Run Dendrix installscript"
            echo -e "  \e[33mnmtui\e[0m         - Connect to Wi-Fi"
            echo -e "  \e[33mdisko\e[0m         - Run declarative partitioning"
            echo ""
          '';
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
