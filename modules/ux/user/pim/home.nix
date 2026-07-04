{self, ...}: {
  flake.homeModules.pim = {pkgs, ...}: {
    imports = [
      self.homeModules.awww
      self.homeModules.bat
      self.homeModules.eza
      self.homeModules.fastfetch
      self.homeModules.git
      self.homeModules.kitty
      self.homeModules.lazygit
      self.homeModules.niri
      self.homeModules.noctalia
      self.homeModules.nvf
      self.homeModules.rofi
      self.homeModules.scripts
      self.homeModules.starship
      self.homeModules.tmux
      self.homeModules.wallpapers
      self.homeModules.zoxide
      self.homeModules.zsh
    ];
    home = {
      username = "pim";
      homeDirectory = "/home/pim";
      stateVersion = "25.05";
    };
  };
}
