{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.stylix = {
    pkgs,
    lib,
    options,
    ...
  }: let
    catppuccin-wall = pkgs.fetchurl {
      url = "https://files.orangc.net/media/walls-catppuccin-mocha/abstract-swirls.jpg";
      sha256 = "sha256-QyvJgQ7FHLoFmeVc9HPQSnOEmT0aAEpWFblh6PDyluw=";
    };
  in {
    imports = [inputs.stylix.nixosModules.stylix];
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
        # Disable problematic or unused targets
      } // lib.optionalAttrs (options.stylix.targets ? plymouth) {
        plymouth.enable = false;
      } // lib.optionalAttrs (options.stylix.targets ? kmscon) {
        kmscon.enable = false;
      } // lib.optionalAttrs (options.stylix.targets ? niri) {
        niri.enable = false;
      } // lib.optionalAttrs (options.stylix.targets ? vesktop) {
        vesktop.enable = false;
      };
    };
  };
}
