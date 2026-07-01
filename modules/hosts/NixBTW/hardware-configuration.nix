{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.NixBTW = {
    config,
    lib,
    pkgs,
    modulesPath,
    ...
  }: {
    imports = [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

    boot.initrd.availableKernelModules = ["xhci_pci" "nvme" "usbhid" "sdhci_pci"];
    boot.initrd.kernelModules = [];
    boot.kernelModules = ["kvm-intel"];
    boot.extraModulePackages = [];

    fileSystems."/" = {
      device = "/dev/disk/by-uuid/62636e01-0a9c-4190-8dd8-f7e610ff1b96";
      fsType = "ext4";
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-uuid/4E84-7046";
      fsType = "vfat";
      options = ["fmask=0022" "dmask=0022"];
    };

    fileSystems."/home" = {
      device = "/dev/disk/by-uuid/be0e43a6-8d98-48bf-aafe-acbb5f835aee";
      fsType = "ext4";
      options = ["defaults"];
    };

    swapDevices = [
      {device = "/dev/disk/by-uuid/edef92f6-2a18-415a-90f1-f17088a9b01e";}
    ];

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };
}
