{
  self,
  inputs,
  ...
}: let
  pimHomeModule = {pkgs, ...}: {
    imports = [
      self.homeModules.bat
      self.homeModules.eza
      self.homeModules.fastfetch
      self.homeModules.git
      self.homeModules.kitty
      self.homeModules.lazygit
      self.homeModules.niri
      self.homeModules.noctalia
      self.homeModules.nvf
      self.homeModules.starship
      self.homeModules.tmux
      self.homeModules.wallpapers
      self.homeModules.zoxide
      self.homeModules.zsh
    ];
    home = {
      username = "pim";
      homeDirectory = "/home/pim";
      stateVersion = "25.05";
    };
  };

  # Share stylix config between NixOS and standalone HM
  stylixConfig = {
    options,
    pkgs,
    lib,
    ...
  }: let
    catppuccin-wall = pkgs.fetchurl {
      url = "https://files.orangc.net/media/walls-catppuccin-mocha/abstract-swirls.jpg";
      sha256 = "sha256-QyvJgQ7FHLoFmeVc9HPQSnOEmT0aAEpWFblh6PDyluw=";
    };
  in {
    stylix = {
      enable = true;
      image = catppuccin-wall;
      polarity = "dark";
      opacity.terminal = 0.7;
      cursor = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Ice";
        size = 24;
      };
      fonts = {
        monospace = {
          package = pkgs.nerd-fonts.jetbrains-mono;
          name = "JetBrains Mono";
        };
        sansSerif = {
          package = pkgs.nerd-fonts.jetbrains-mono;
          name = "JetBrains Mono";
        };
        serif = {
          package = pkgs.nerd-fonts.jetbrains-mono;
          name = "JetBrains Mono";
        };
        sizes = {
          applications = 12;
          terminal = 15;
          desktop = 11;
          popups = 12;
        };
      };
      targets = {
        nvf.enable = false;
        # Only set NixOS targets if the option exists (i.e., we are in a NixOS module)
      } // lib.optionalAttrs (options.stylix.targets ? plymouth) {
        plymouth.enable = false;
      } // lib.optionalAttrs (options.stylix.targets ? kmscon) {
        kmscon.enable = false;
      };
    };
  };
in {
  flake.homeModules.pim = pimHomeModule;

  flake.homeConfigurations.pim = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = import inputs.nixpkgs {system = "x86_64-linux";};
    modules = [
      inputs.stylix.homeManagerModules.stylix
      stylixConfig
      pimHomeModule
    ];
    extraSpecialArgs = {
      inherit self inputs;
      hostName = "NixBTW"; # Default for standalone
    };
  };

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
      extraSpecialArgs = {
        inherit self inputs;
        hostName = config.networking.hostName;
      };
      users.pim = {
        imports = [pimHomeModule];
      };
    };

    users.users.pim = {
      isNormalUser = true;
      description = "Main user";
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
  };
}
