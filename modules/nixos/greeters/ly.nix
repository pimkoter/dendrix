{
  flake.nixosModules.ly = {
    services.displayManager.ly = {
      enable = true;

      settings = {
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
