{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.kiki = {
    config,
    pkgs,
    ...
  }: let
    packagesJsonPath = ./packages.json;
    packagesJson =
      if builtins.pathExists packagesJsonPath
      then builtins.fromJSON (builtins.readFile packagesJsonPath)
      else {};

    packageNames = builtins.attrNames packagesJson;

    jsonPackages =
      builtins.filter
      (pkg: pkg != null)
      (map
        (name:
          if builtins.hasAttr name pkgs
          then builtins.hasAttr name pkgs
          else null)
        packageNames);
  in {
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
        home.packages = jsonPackages;
        stylix.targets = {
          kde.enable = false;
          qt.enable = false;
        };
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
