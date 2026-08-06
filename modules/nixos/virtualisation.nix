{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.virtualisation = {pkgs, ...}: {
    virtualisation = {
      libvirtd = {
        enable = true;
        qemu.swtpm.enable = true;
      };
      docker = {
        enable = true;
        enableOnBoot = false;
      };
      spiceUSBRedirection.enable = true;
    };

    programs = {
      virt-manager.enable = true;
      dconf.enable = true;
    };

    environment.systemPackages = with pkgs; [
      qemu_kvm
      virt-manager
      virt-viewer
      OVMF # UEFI for Windows/Linux
    ];

    services.spice-vdagentd.enable = true;

    # KVM acceleration
    boot.kernelModules = ["kvm-intel"];
  };
}
