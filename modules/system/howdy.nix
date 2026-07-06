{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.howdy = {
    lib,
    config,
    pkgs,
    ...
  }: {
    config = {
      services.howdy = {
        enable = true;
        control = "sufficient";
        settings = {
          video = {
            device_path = "/dev/video2";
          };
        };
      };

      services.linux-enable-ir-emitter.enable = true;

      # Dynamically inject PAM rules by checking which display manager is enabled
      security.pam.services =
        # Check for Ly
        (lib.mkIf (config.services.displayManager.ly.enable or false) {
          ly.rules.auth.howdy = lib.mkDefault {
            order = 10;
            control = "sufficient";
            modulePath = "pam_howdy.so";
          };
        })
        // # Merge with check for SDDM
        (lib.mkIf (config.services.displayManager.sddm.enable or false) {
          sddm.rules.auth.howdy = lib.mkDefault {
            order = 10;
            control = "sufficient";
            modulePath = "pam_howdy.so";
          };
        });
    };
  };
}
