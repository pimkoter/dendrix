{
  self,
  inputs,
  ...
}: {
  flake.homeModules.tmux = {pkgs, ...}: {
    programs.tmux = {
      enable = true;
      mouse = true;
      shell = "${pkgs.zsh}/bin/zsh";
      prefix = "C-a";
      terminal = "kitty";
    };
  };
}
