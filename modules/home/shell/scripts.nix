{ self, ... }:
{
  flake.homeModules.scripts =
    { config, pkgs, ... }:
    {
      home.packages = with self.packages.${pkgs.stdenv.hostPlatform.system}; [
        add-ip
        clone-repos
        dendrix-install
        noctalia-to-nix
        rofi-bookmarks
        rofi-repos
        rofi-ssh
        rofi-wallpaper
      ];
    };
}
