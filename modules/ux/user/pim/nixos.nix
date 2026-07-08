{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.pim = {
    config,
    pkgs,
    ...
  }: {
    imports = [
      inputs.home-manager.nixosModules.home-manager
    ];

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "backup";
      extraSpecialArgs = {
        inherit self inputs;
        hostName = config.networking.hostName;
      };
      users.pim = {
        imports = [self.homeModules.pim];
      };
    };

    users.users.pim = {
      isNormalUser = true;
      description = "Pim";
      initialPassword = "12345";
      extraGroups = [
        "wheel"
        "networkmanager"
        "wireshark"
        "docker"
        "libvirtd"
        "kvm"
      ];
      ignoreShellProgramCheck = true;
      shell = pkgs.zsh;
    };
  };
}
