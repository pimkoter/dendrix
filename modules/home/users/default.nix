{
  self,
  inputs,
  ...
}:
{
  flake = {
    # 1. HOME MANAGER PROFILE: Your apps, themes, and shell configs
    homeModules.default = { pkgs, ... }: {
      imports = with self.homeModules; [
        #
        #

        # ADD YOUR HOME MODULES HERE

        #
        #
        #
      ];

      home = {
        username = "default";
        homeDirectory = "/home/default";
        stateVersion = "25.05";
        pointerCursor.enable = true;
        packages = with pkgs; [
          #
          #

          # ADD ADDITIONAL PACKAGES HERE

          #
          #
          #
        ];
      };
    };

    # 2. NIXOS CONFIGURATION
    nixosModules.default =
      {
        config,
        pkgs,
        ...
      }:
      {
        imports = [
          inputs.home-manager.nixosModules.home-manager
        ];

        users.users.default = {
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

        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          backupFileExtension = "backup";
          extraSpecialArgs = {
            inherit self inputs;
            hostName = config.networking.hostName;
          };
          users.default = {
            imports = [ self.homeModules.default ];
          };
        };
      };
  };
}
