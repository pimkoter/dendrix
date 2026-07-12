{self, ...}: {
  flake.homeModules.chicago95 = {pkgs, ...}: let
    chicago95-src = pkgs.fetchFromGitHub {
      owner = "grassmunk";
      repo = "Chicago95";
      rev = "v3.0.1";
      hash = "sha256-4YtI8yS/tS/m7bLRE9j039ZqNInmKcoT96fS0pZ62rM=";
    };
  in {
    home.packages = with pkgs; [
      xfce.xfce4-whiskermenu-plugin # Start Menu applet
    ];

    # Symlink assets directly into kiki's user directory
    home.file = {
      ".themes/Chicago95".source = "${chicago95-src}/Theme/Chicago95";
      ".icons/Chicago95".source = "${chicago95-src}/Icons/Chicago95";
      ".icons/Chicago95-cursors".source = "${chicago95-src}/Cursors/Chicago95-Cursors";
    };

    # Force standard GTK apps (Web browsers, etc.) to use the retro skin
    gtk = {
      enable = true;
      theme.name = "Chicago95";
      iconTheme.name = "Chicago95";
      cursorTheme = {
        name = "Chicago95-cursors";
        size = 16;
      };
      font = {
        name = "MS Sans Serif";
        size = 9;
      };
    };

    # Write straight to the XFCE settings manager database
    xfconf.settings = {
      xsettings = {
        "Net/ThemeName" = "Chicago95";
        "Net/IconThemeName" = "Chicago95";
        "Gtk/CursorThemeName" = "Chicago95-cursors";
        "Gtk/FontName" = "MS Sans Serif 9";
      };
      xfwm4 = {
        "theme" = "Chicago95";
        "title_font" = "MS Sans Serif Bold 9";
        "button_layout" = "O|HMC"; # Hidden/Minimize, Maximize, Close on right side
      };
      xfce4-desktop = {
        "backdrop/screen0/monitor0/workspace0/color-style" = 0; # Solid color mode
        "backdrop/screen0/monitor0/workspace0/rgba1" = [0.0 0.50196 0.50196 1.0]; # #008080 Classic Teal
        "backdrop/screen0/monitor0/workspace0/image-style" = 0; # Disable wallpapers
      };
    };
  };
}
