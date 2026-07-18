{
  self,
  inputs,
  ...
}: {
  flake = {
    # 1. HOME MANAGER PROFILE: Your apps, themes, and shell configs
    homeModules.pim = {pkgs, ...}: {
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
        scripts
        starship
        tmux
        wallpapers
        zoxide
        zsh
      ];

      home = {
        username = "pim";
        homeDirectory = "/home/pim";
        stateVersion = "25.05";
        pointerCursor.enable = true;
        packages = with pkgs; [
          # Apps & Desktop Production
          evince
          obsidian
          qbittorrent
          spotify
          thunderbird

          # Development & Networking
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

          # Gaming Ecosystem
          heroic
          prismlauncher
          satisfactorymodmanager
          vesktop

          # Terminal Rice & Visuals
          cava
          cmatrix
          gping

          # Terminal Utilities
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

          # External Flake Inputs
          inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
          inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
          inputs.zennotes.packages.${pkgs.stdenv.hostPlatform.system}.zennotes-desktop
        ];
      };
    };

    # 2. NIXOS CONFIGURATION
    nixosModules.pim = {
      config,
      pkgs,
      ...
    }: {
      imports = [
        inputs.home-manager.nixosModules.home-manager
      ];

      users.users.pim = {
        isNormalUser = true;
        description = "Pim";
        initialPassword = "12345";
        extraGroups = ["wheel" "networkmanager" "wireshark" "docker" "libvirtd" "kvm"];
        ignoreShellProgramCheck = true;
        shell = pkgs.zsh;
      };

      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "backup";
        extraSpecialArgs = {
          inherit self inputs;
          hostName = config.networking.hostName;
        };
        users.pim = {
          imports = [self.homeModules.pim];
        };
      };
    };
  };
}
