{
  self,
  inputs,
  ...
}:
{
  flake = {
    # 1. HOME MANAGER PROFILE: Your apps, themes, and shell configs
    homeModules.wsl = { pkgs, ... }: {
      imports = with self.homeModules; [
        bat
        eza
        fastfetch
        git
        kitty
        lazygit
        nvf
        starship
        stylix
        tmux
        xonsh
        zoxide
      ];

      home = {
        username = "wsl";
        homeDirectory = "/home/wsl";
        stateVersion = "25.05";
        pointerCursor.enable = true;

        sessionVariables = {
          TS_SEARCH_PATHS = "$HOME:1 $HOME/Repos:2 $HOME/Projects:2";
        };

        packages = with pkgs; [
          inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
        ];
      };
    };

    # 2. NIXOS CONFIGURATION
    nixosModules.wsl =
      {
        config,
        pkgs,
        ...
      }:
      {
        imports = [
          inputs.home-manager.nixosModules.home-manager
        ];

        users.users.wsl = {
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
        };

        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          backupFileExtension = "backup";
          extraSpecialArgs = {
            inherit self inputs;
            hostName = config.networking.hostName;
          };
          users.wsl = {
            imports = [ self.homeModules.wsl ];
          };
        };
      };
  };
}
