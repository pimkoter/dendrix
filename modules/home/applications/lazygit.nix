{
  flake.homeModules.lazygit = {
    programs.lazygit = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        os.editPreset = "nvim";
      };
    };
  };
}
