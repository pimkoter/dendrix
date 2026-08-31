{
  flake.homeModules.git = {
    programs.git = {
      enable = true;
      settings = {
        user.name = "pimkoter";
        user.email = "pimkoter69@gmail.com";
        init.defaultBranch = "main";
        pull.rebase = true;
        color.ui = "auto";
      };
    };
  };
}
