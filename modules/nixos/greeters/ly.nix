{
  flake.nixosModules.ly =
    {
      config,
      pkgs,
      ...
    }:
    {
      # Enable the Ly Display Manager
      services.displayManager.ly = {
        enable = true;

        # Custom configuration settings mapping to Ly's config.ini
        settings = {
          # Visual & Animation Customization
          animation = 1;
          bigclock = true;
          blank_password = false;
          clear_password = true;

          # Environment Defaults
          default_rm = true;
          hide_borders = false;

          # Language and Console settings
          lang = "en";
          log = "/var/log/ly-session.log";
        };
      };
    };
}
