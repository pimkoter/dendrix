{
  flake.themes.nord =
    { pkgs }:
    let
      repo = pkgs.fetchFromGitHub {
        owner = "linuxdotexe";
        repo = "nordic-wallpapers";
        rev = "master";
        hash = "sha256-clRGfUqKD4/v5bNj/lI5pKDdf6qraZXJBWZtBLLqF50=";
      };
      wallpapers = "${repo}/wallpapers";
    in
    {
      name = "nord";
      inherit wallpapers;
      defaultWallpaper = "${wallpapers}/ign_nordhills.png";
      stylixBase16theme = "${pkgs.base16-schemes}/share/themes/nord.yaml";
      nvfTheme = "nord";
      polarity = "dark";
    };
}
