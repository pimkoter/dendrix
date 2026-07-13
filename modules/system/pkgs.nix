{
  flake.nixosModules.pkgs = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      # --- Display & Wayland Environment ---
      xdg-desktop-portal-gnome # Screensharing tool / portal
      xwayland # X11 compatibility layer for Wayland
      xwayland-satellite # Isolated Xwayland helper

      # --- Hardware & Audio Management ---
      blueman # Bluetooth manager GUI
      pavucontrol # PulseAudio/pipewire volume control GUI

      # --- Core System Utilities ---
      curl # Command-line HTTP client
      git # Version control system
      polkit # Authorization framework
    ];
  };
}
