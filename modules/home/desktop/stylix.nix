{
  self,
  inputs,
  lib,
  ...
}:
let
  defaultThemeName = self.defaultTheme or "catppuccin";
in
{
  options = {
    flake.themes = lib.mkOption {
      type = lib.types.lazyAttrsOf lib.types.raw;
      default = { };
      description = "Theme definitions";
    };

    flake.defaultTheme = lib.mkOption {
      type = lib.types.str;
      default = "catppuccin";
      description = "Name of the default theme to use";
    };
  };

  config = {
    flake = {
      commonStylix =
        { pkgs }:
        let
          themes = builtins.mapAttrs (_: themeFn: themeFn { inherit pkgs; }) (self.themes or { });
          activeTheme = themes.${defaultThemeName} or (builtins.head (builtins.attrValues themes));
          resolveImage = theme:
            if builtins.isString theme.defaultWallpaper && !(lib.hasPrefix "/" theme.defaultWallpaper)
            then "${theme.wallpapers}/${theme.defaultWallpaper}"
            else theme.defaultWallpaper;
        in
        {
          stylix = {
            enable = true;
            image = resolveImage activeTheme;
            polarity = activeTheme.polarity or "dark";
            base16Scheme = activeTheme.stylixBase16theme;

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
          };
        };

      homeModules.stylix =
        { pkgs, ... }:
        let
          themes = builtins.mapAttrs (_: themeFn: themeFn { inherit pkgs; }) (self.themes or { });
          activeTheme = themes.${defaultThemeName} or (builtins.head (builtins.attrValues themes));
        in
        {
          home.file.".wallpapers".source = activeTheme.wallpapers;
        };

      nixosModules.stylix =
        { pkgs, lib, ... }:
        let
          themes = builtins.mapAttrs (_: themeFn: themeFn { inherit pkgs; }) (self.themes or { });
          resolveImage = theme:
            if builtins.isString theme.defaultWallpaper && !(lib.hasPrefix "/" theme.defaultWallpaper)
            then "${theme.wallpapers}/${theme.defaultWallpaper}"
            else theme.defaultWallpaper;
        in
        {
          imports = [
            inputs.stylix.nixosModules.stylix
            (self.commonStylix { inherit pkgs; })
          ];

          home-manager.users.pim = {
            stylix = {
              base16Scheme = (themes.${defaultThemeName} or (builtins.head (builtins.attrValues themes))).stylixBase16theme;
              polarity = (themes.${defaultThemeName} or (builtins.head (builtins.attrValues themes))).polarity or "dark";
              image = resolveImage (themes.${defaultThemeName} or (builtins.head (builtins.attrValues themes)));
            };
            home.file.".wallpapers".source = (themes.${defaultThemeName} or (builtins.head (builtins.attrValues themes))).wallpapers;
          };

          # -----------------------------------------------------------------
          # NixOS Specialisations for switching themes on the fly
          # -----------------------------------------------------------------
          specialisation = builtins.mapAttrs (
            themeName: theme: {
              inheritParentConfig = true;
              configuration = {
                stylix = {
                  base16Scheme = lib.mkForce theme.stylixBase16theme;
                  polarity = lib.mkForce (theme.polarity or "dark");
                  image = lib.mkForce (resolveImage theme);
                };

                home-manager.users.pim = {
                  stylix = {
                    base16Scheme = lib.mkForce theme.stylixBase16theme;
                    polarity = lib.mkForce (theme.polarity or "dark");
                    image = lib.mkForce (resolveImage theme);
                  };
                  home.file.".wallpapers".source = lib.mkForce theme.wallpapers;
                };
              };
            }
          ) themes;
        };
    };
  };
}
