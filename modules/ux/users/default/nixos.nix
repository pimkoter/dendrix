{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.default = {
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
      users.default = {
        imports = [self.homeModules.default];
        home.packages = jsonPackages;
        stylix.targets = {
          kde.enable = false;
          qt.enable = false;
        };
      };
    };

    users.users.default = {
      isNormalUser = true;
      description = "default";
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
