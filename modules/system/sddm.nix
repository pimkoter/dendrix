{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.sddm = {
    pkgs,
    config,
    lib,
    ...
  }: {
    services.displayManager = {
      defaultSession = "niri";
      sddm = {
        package = pkgs.kdePackages.sddm;
        enable = true;
        wayland.enable = true;
        theme = "sddm-astronaut-theme";
      };
    };
  };
}
