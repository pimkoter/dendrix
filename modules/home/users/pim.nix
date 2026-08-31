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
        inputs,
        ...
      }:
      {
        imports = with self.homeModules; [
          inputs.sops-nix.homeManagerModules.sops
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
          scripts
          starship
          stylix
          tmux
          wallpapers
          xonsh
          zoxide
        ];

        sops = {
          defaultSopsFile = ../../secrets/secrets.yaml;
          age = {
            keyFile = "/home/pim/.config/sops/age/keys.txt";
            sshKeyPaths = [
              "/etc/ssh/ssh_host_ed25519_key"
              "/preserve/etc/ssh/ssh_host_ed25519_key"
            ];
          };
        };

        home = {
          username = "pim";
          homeDirectory = "/home/pim";
          stateVersion = "25.05";
          pointerCursor.enable = true;

          sessionVariables = {
            # Tmux sessionizer path settings
            TS_SEARCH_PATHS = "$HOME:1 $HOME/Repos:2 $HOME/Projects:2";
          };

          packages = with pkgs; [
            # Desktop applications
            evince
            qbittorrent
            spotify
            thunderbird

            # Development
            android-studio
            android-tools
            adb-sync
            cargo
            clang
            compose2nix
            python315
            rustc
            sdkmanager

            # Networking
            wifi-qr
            geteduroam
            dig
            nmap

            # Gaming
            heroic
            prismlauncher
            satisfactorymodmanager

            # Communication
            vesktop

            # CLI utilities
            bat
            bottom
            fd
            ffmpeg
            fzf
            jq
            lazygit
            ripgrep
            sops
            unzip
            wl-clipboard-rs

            # Browsers / Desktop
            inputs.vm-curator.packages.${pkgs.stdenv.hostPlatform.system}.default
            inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
            inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
            inputs.zennotes.packages.${pkgs.stdenv.hostPlatform.system}.zennotes-desktop

            # Misc
            (lib.lowPrio pkgs.gh)
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
          hashedPasswordFile = config.sops.secrets."passwords/pim".path;
          extraGroups = [
            "wheel"
            "networkmanager"
            "wireshark"
            "docker"
            "libvirtd"
            "kvm"
            "sops"
          ];
          ignoreShellProgramCheck = true;
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
            "Virtualmachines"
            ".thunderbird"
            ".config/zen"
            ".config/sops"
            ".local/share/xonsh/history_json"
            ".local/share/zoxide"
          ];
          files = [
            ".ssh/known_hosts"
            ".ssh/authorized_keys"
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
