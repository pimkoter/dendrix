{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.pkgs = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      # --- System & Core Utilities ---
      bat # cat clone with syntax highlighting
      blueman # Bluetooth manager GUI
      bottom # System monitor (htop-like)
      curl # Command-line HTTP client
      ffmpeg # Audio/video processing toolkit
      fzf # Fuzzy finder
      git # Version control system
      lazygit # TUI Git client
      neovim # Vim-based text editor
      openrgb # RGB lighting control software
      pavucontrol # PulseAudio/pipewire volume control GUI
      polkit # Authorization framework
      ripgrep # Fast recursive search (grep alternative)
      starship # Cross-shell prompt
      unzip # Zipping tool
      wl-clipboard-rs # Wayland clipboard utilities (wl-copy/wl-paste)
      xdg-desktop-portal-gnome # Screensharing tool
      xwayland # X11 compatibility layer for Wayland
      xwayland-satellite # Isolated Xwayland helper

      # --- Apps & Production ---
      evince # PDF/document viewer
      kitty # GPU-accelerated terminal emulator
      obsidian # Markdown knowledge base
      qbittorrent # BitTorrent client
      spotify # Music streaming client
      thunderbird # Email Client
      winboat # Windows emulation software

      # --- Gaming Ecosystem ---
      heroic # Epic/GOG game launcher
      legcord # Discord client
      prismlauncher # Minecraft launcher
      satisfactorymodmanager # Modmanager for satisfactory
      steam # Steam game platform client

      # --- Development & Networking ---
      compose2nix # Tool for transferring docker-compose.yaml to .nix files
      dig # DNS Tester
      gcc # C / C++ compiler
      nmap # Network Mapper
      python315 # Python compiler
      sdkmanager # Android tool
      adb-sync # App to sync acces android files
      android-tools # Fastboot options
      android-studio # Android Studio IDE

      # --- Terminal Rice & Visuals ---
      cava # Terminal audio visualizer
      cmatrix # Matrix-style terminal screensaver
      fastfetch # System info fetch tool
      gping # Graphical Ping Utility

      # --- Flake Inputs (External Packages) ---
      inputs.helium-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
      inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };
}
