{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.misc = {
    config,
    pkgs,
    lib,
    ...
  }: {
    xdg.portal.wlr.enable = true;

    fonts = {
      fontconfig.enable = true;
      packages = with pkgs; [
        nerd-fonts.jetbrains-mono
        noto-fonts-cjk-sans
      ];
    };

    security = {
      polkit.enable = true;
    };

    services.gnome.gnome-keyring.enable = false;

    environment.variables = {
      LD_LIBRARY_PATH = "/run/opengl-driver/lib";
      ELECTRON_OZONE_PLATFORM_HINT = "wayland";
      OZONE_PLATFORM = "wayland";
      GDK_BACKEND = "wayland";
    };

    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    nixpkgs.config = {
      allowUnfree = true;
      permittedInsecurePackages = [
        "pnpm-10.29.2"
        "electron-40.10.5"
      ];
    };

    time.timeZone = "Europe/Amsterdam";
    i18n.defaultLocale = "en_US.UTF-8";

    system.stateVersion = "25.11";
  };
}
