{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.pim = {
    home-manager.users.pim = {
      imports = with self.homeModules; [
        bat
        eza
        fastfetch
        git
        kitty
        lazygit
        niri
        noctalia
        nvf
        starship
        tmux
        wallpapers
        zoxide
        zsh
      ];
    };
  };
}
