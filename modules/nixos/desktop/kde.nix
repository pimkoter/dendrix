{
  flake.nixosModules.kde = {
    services.desktopManager.plasma6 = {
      enable = true;
    };
  };
}
