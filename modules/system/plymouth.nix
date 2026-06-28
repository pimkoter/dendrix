{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.plymouth = {pkgs, ...}: let
    theme = "black_hud";
  in {
    boot = {
      plymouth = {
        enable = false;
        theme = theme;
        themePackages = with pkgs; [
          (adi1090x-plymouth-themes.override {
            selected_themes = [theme];
          })
        ];
      };

      consoleLogLevel = 3;
      initrd.verbose = false;
      kernelParams = [
        "quiet"
        "udev.log_level=3"
        "systemd.show_status=auto"
      ];
      loader.timeout = null;
    };
  };
}
