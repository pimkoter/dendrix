{self, ...}: {
  flake.homeModules.default = {pkgs, ...}: {
    imports = [
      self.homeModules.bat
      self.homeModules.eza
      self.homeModules.fastfetch
      self.homeModules.kitty
      self.homeModules.nvf
      self.homeModules.rofi
      self.homeModules.starship
      self.homeModules.tmux
      self.homeModules.zoxide
      self.homeModules.zsh
    ];
    home = {
      username = "default";
      homeDirectory = "/home/default";
      stateVersion = "25.05";
    };
  };
}
