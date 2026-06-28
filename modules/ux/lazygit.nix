{
  self,
  inputs,
  ...
}: {
  flake.homeModules.lazygit = {
    programs.lazygit = {
      enable = true;
      enableZshIntegration = true;
      settings = {
      };
    };
  };
}
