{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.pim = {
    config,
    pkgs,
    ...
  }: {
    imports = [
      inputs.home-manager.nixosModules.home-manager
    ];

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
        home = {
          pointerCursor.enable = true;
          packages = with pkgs; [
            # --- Apps & Desktop Production ---
            evince # PDF/document viewer
            kitty # GPU-accelerated terminal emulator
            obsidian # Markdown knowledge base
            qbittorrent # BitTorrent client
            spotify # Music streaming client
            thunderbird # Email Client

            # --- Development & Networking ---
            adb-sync # App to sync access android files
            android-studio # Android Studio IDE
            android-tools # Fastboot options
            cargo # Rust package manager
            clang # C compiler
            compose2nix # Tool for transferring docker-compose.yaml to .nix files
            dig # DNS Tester
            nmap # Network Mapper
            python315 # Python interpreter
            rustc # Rust compiler
            sdkmanager # Android tool

            # --- Gaming Ecosystem ---
            heroic # Epic/GOG game launcher
            prismlauncher # Minecraft launcher
            satisfactorymodmanager # Modmanager for satisfactory
            vesktop # Discord client

            # --- Terminal Rice & Visuals ---
            cava # Terminal audio visualizer
            cmatrix # Matrix-style terminal screensaver
            gping # Graphical Ping Utility

            # --- Terminal Utilities ---
            bat # cat clone with syntax highlighting
            bottom # System monitor (htop-like)
            fd # Better find alternative
            ffmpeg # Audio/video processing toolkit
            fzf # Fuzzy finder
            jq # JSON tool
            lazygit # TUI Git client
            sops # Secret management
            ripgrep # Fast recursive search (grep alternative)
            unzip # Zipping tool
            wl-clipboard-rs # Wayland clipboard utilities (wl-copy/wl-paste)

            # --- Flake Inputs (External Packages) ---
            inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
            inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
            inputs.zennotes.packages.${pkgs.stdenv.hostPlatform.system}.zennotes-desktop
          ];
        };
      };
    };

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
      shell = pkgs.zsh;
    };
  };
}
