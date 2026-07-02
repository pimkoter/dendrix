{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.boot = {
    config,
    pkgs,
    stable,
    ...
  }: {
    boot = {
      kernelPackages = pkgs.linuxPackages_zen;
      extraModulePackages = [config.boot.kernelPackages.v4l2loopback];
      kernel.sysctl = {"vm.max_map_count" = 2147483642;};
      kernelModules = ["nvidia"];

      initrd.kernelModules = ["nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" "i915"];
      initrd.systemd.enable = true;

      consoleLogLevel = 3;
      initrd.verbose = false;
      kernelParams = [
        "quiet"
        "splash"
        "boot.shell_on_fail"
        "loglevel=3"
        "rd.systemd.show_status=false"
        "rd.udev.log_level=3"
        "nvidia-drm.modeset=1"
        "nvidia-drm.fbdev=1"
        "i915.enable_psr=0"
        "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
        "video=2560x1600"
        "video=efifb:mode=0"
        "vt.global_cursor_default=0"
        "acpi_osi=Linux"
      ];

      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
        timeout = null;
      };
    };
  };
}
