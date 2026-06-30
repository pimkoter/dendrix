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
        extraPackages = [
          pkgs.sddm-astronaut
        ];
      };
    };

    environment.systemPackages = [
      pkgs.sddm-astronaut
    ];
  };
}
