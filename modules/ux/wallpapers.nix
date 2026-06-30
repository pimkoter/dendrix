{
  self,
  inputs,
  ...
}: {
  flake.homeModules.wallpapers = {
    config,
    pkgs,
    ...
  } @ args: let
    catppuccin-walls = pkgs.fetchFromGitHub {
      owner = "orangci";
      repo = "walls-catppuccin-mocha";
      rev = "master";
      sha256 = "sha256-N+MZHSRcwOldS5Ai8B3YfKquKs9oeUW/GkV1iKM5+i8=";
    };
  in {
    home.file.".System/modules/.wallpapers".source = catppuccin-walls;
  };
}
