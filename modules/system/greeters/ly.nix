{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.ly = {
    config,
    pkgs,
    ...
  }: {
    # Enable the Ly Display Manager
    services.displayManager.ly = {
      enable = true;

      # Custom configuration settings mapping to Ly's config.ini
      settings = {
        # Visual & Animation Customization
        animation = 1; # 0 = none, 1 = matrix, 2 = fire
        bigclock = true; # Use standard big clock style
        blank_password = false; # Mask password with asterisks
        clear_password = false; # Wipe screen on wrong password

        # Environment Defaults
        default_rm = true; # Auto remove standard desktop environments from menu if needed
        hide_borders = false; # Show/hide terminal borders around box

        # Language and Console settings
        lang = "en";
        tty = 2; # The TTY Ly will run on (default is usually 2)
      };
    };
  };
}
