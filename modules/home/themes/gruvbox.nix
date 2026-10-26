{
  flake.themes.gruvbox =
    { pkgs }:
    let
      repo = pkgs.fetchFromGitHub {
        owner = "AngelJumbo";
        repo = "gruvbox-wallpapers";
        rev = "main";
        hash = "sha256-0BvY2cNCQdUcCC8jRzrLSXsDrFjerrWvcUZtOo/0e0c=";
      };
      wallpapers = "${repo}/wallpapers";
    in
    {
      name = "gruvbox";
      inherit wallpapers;
      defaultWallpaper = "${wallpapers}/minimalistic/fox.png";
      stylixBase16theme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";
      nvfTheme = "gruvbox";
      polarity = "dark";
    };
}
