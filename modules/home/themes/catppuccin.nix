{
  flake.themes.catppuccin =
    { pkgs }:
    let
      wallpapers = pkgs.fetchFromGitHub {
        owner = "orangci";
        repo = "walls-catppuccin-mocha";
        rev = "master";
        hash = "sha256-N+MZHSRcwOldS5Ai8B3YfKquKs9oeUW/GkV1iKM5+i8=";
      };
    in
    {
      name = "catppuccin";
      inherit wallpapers;
      defaultWallpaper = "${wallpapers}/abstract-swirls.jpg";
      stylixBase16theme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
      nvfTheme = "catppuccin";
      polarity = "dark";
    };
}
