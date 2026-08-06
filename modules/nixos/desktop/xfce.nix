{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.xfce = {pkgs, ...}: {
    services.xserver = {
      enable = true;

      # Standard desktop environment setup for traditional Windows users
      desktopManager = {
        xfce = {
          enable = true;
          noDeExtras = false; # Delivers stock file managers and applet settings
        };
      };

      # LightDM provides a stable, uncomplicated graphical login greeting screen
      displayManager.lightdm.enable = true;
    };

    # System-wide retro fonts
    fonts.packages = with pkgs; [
      corefonts
    ];
  };
}
