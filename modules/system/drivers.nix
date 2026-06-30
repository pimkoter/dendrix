{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.drivers = {config, pkgs, ...}: {
    services.xserver.videoDrivers = ["nvidia" "intel"];
    hardware = {
      nvidia = {
        modesetting.enable = true;
        open = false;
        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.latest;
        powerManagement = {
          enable = true;
          finegrained = true;
        };
        prime = {
          offload = {
            enable = true;
            enableOffloadCmd = true;
          };
          intelBusId = "PCI:0:2:0";
          nvidiaBusId = "PCI:2:0:0";
        };
      };

      graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = with pkgs; [
          intel-media-driver
          libvdpau-va-gl
          nvidia-vaapi-driver
          egl-wayland
        ];
      };
    };
  };
}
