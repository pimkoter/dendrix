{ self, ... }:
{
  flake.homeModules.scripts =
    { pkgs, ... }:
    {
      home.packages = with self.packages.${pkgs.stdenv.hostPlatform.system}; [
        add-ip
        clone-repos
        hackermode
        install
        noctalia-bookmarks
        noctalia-clipboard
        noctalia-repos
        noctalia-ssh
        noctalia-theme
        noctalia-to-nix
        rofi-bookmarks
        rofi-clipboard
        rofi-repos
        rofi-ssh
        rofi-theme
        rofi-wallpaper-awww
      ];
    };
}
