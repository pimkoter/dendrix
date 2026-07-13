{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.kde = {
    config,
    pkgs,
    lib,
    ...
  }: {
    services.desktopManager.plasma6 = {
      enable = true;
    };
  };
}
