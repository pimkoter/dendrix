{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.kiki = {
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
      users.kiki = {
        imports = [self.homeModules.kiki];
      };
    };

    users.users.kiki = {
      isNormalUser = true;
      description = "Kiki";
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
