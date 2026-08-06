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
    config = let
      pkgs-stable = import inputs.nixpkgs-stable {
        inherit (pkgs.stdenv.hostPlatform) system;
        config = {
          allowUnfree = true;
        };
      };
    in {
      # The rest of your module config block stays exactly the same...
      nixpkgs.overlays = [
        (final: prev: {
          howdy = pkgs-stable.howdy;
          linux-enable-ir-emitter = pkgs-stable.linux-enable-ir-emitter;
        })
      ];

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
