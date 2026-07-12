{self, ...}: {
  flake.homeModules.kiki = {pkgs, ...}: {
    imports = [
      self.homeModules.awww
      self.homeModules.bat
      self.homeModules.chicago95
      self.homeModules.eza
      self.homeModules.fastfetch
      self.homeModules.kitty
      self.homeModules.nvf
      self.homeModules.starship
      self.homeModules.tmux
      self.homeModules.zoxide
      self.homeModules.zsh
    ];
    home = {
      username = "kiki";
      homeDirectory = "/home/kiki";
      stateVersion = "25.05";
    };
  };
}
