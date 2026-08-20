{
  self,
  inputs,
  ...
}:
{
  flake = {

    # ------------------------------------------------------------
    # HOME configuration
    # ------------------------------------------------------------

    homeModules.pim =
      {
        pkgs,
        ...
      }:
      {
        imports = with self.homeModules; [
          awww
          bat
          eza
          fastfetch
          git
          kitty
          lazygit
          niri
          noctalia
          nvf
          rofi
          bashScripts
          pythonScripts
          starship
          stylix
          tmux
          wallpapers
          xonsh
          zoxide
        ];

        home = {
          username = "pim";
          homeDirectory = "/home/pim";
          stateVersion = "25.05";
          pointerCursor.enable = true;

          packages = with pkgs; [
            evince
            qbittorrent
            spotify
            thunderbird

            adb-sync
            android-studio
            android-tools
            cargo
            clang
            compose2nix
            dig
            nmap
            python315
            rustc
            sdkmanager

            heroic
            prismlauncher
            satisfactorymodmanager
            vesktop

            cava
            cmatrix
            gping

            bat
            bottom
            fd
            ffmpeg
            fzf
            jq
            lazygit
            sops
            ripgrep
            unzip
            wl-clipboard-rs

            # Misc
            (lib.lowPrio pkgs.gh)

            inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
            inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
            inputs.zennotes.packages.${pkgs.stdenv.hostPlatform.system}.zennotes-desktop
          ];
        };
      };

    homeConfigurations.pim = inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;

      extraSpecialArgs = {
        inherit self inputs;
      };

      modules = [
        self.homeModules.pim
        inputs.stylix.homeModules.stylix
      ];
    };

    nixosModules.pim =
      {
        config,
        pkgs,
        lib,
        ...
      }:
      {
        imports = [
          inputs.home-manager.nixosModules.home-manager
          inputs.preservation.nixosModules.default
        ];

        # ------------------------------------------------------------
        # SYSTEM identity
        # ------------------------------------------------------------

        users.users.pim = {
          isNormalUser = true;
          description = "Pim";
          initialPassword = "12345";
          extraGroups = [
            "wheel"
            "networkmanager"
            "wireshark"
            "docker"
            "libvirtd"
            "kvm"
          ];
          ignoreShellProgramCheck = true;
          shell = pkgs.xonsh;
        };

        # ------------------------------------------------------------
        # persistent user state
        # ------------------------------------------------------------

        preservation.preserveAt."/preserve".users.pim = {
          directories = [
            "Downloads"
            "Pictures"
            "Backups"
            "Notes"
            "Projects"
            "Repos"
            "Games"
            ".config/zen"
            ".local/share/xonsh/history_json"
            ".local/share/zoxide"
            ".ssh"
          ];
        };

        # ------------------------------------------------------------
        # Home Manager integration
        # ------------------------------------------------------------

        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          backupFileExtension = "backup";

          extraSpecialArgs = {
            inherit self inputs;
            hostName = config.networking.hostName;
          };

          users.pim = {
            imports = [ self.homeModules.pim ];
          };
        };

        nixpkgs.config.allowUnfreePredicate =
          pkg:
          builtins.elem (lib.getName pkg) [
            "spotify"
            "android-sdk-platform-tools"
            "platform-tools"
            "android-studio"
          ];
      };
  };
}
