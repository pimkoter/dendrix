{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.howdy = {
    config,
    pkgs,
    ...
  }: {
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
    security.pam.services.sddm.rules.auth.howdy = {
      order = 10; # Put it at the very beginning of the auth stack
      control = "sufficient";
      modulePath = "pam_howdy.so";
    };
  };
}
