{
  self,
  inputs,
  ...
}: {
  flake.homeModules.git = {config, ...}: {
    programs.git = {
      enable = true;
      settings = {
        user.name = "pimkoter";
        user.email = "pim@koter";
        init.defaultBranch = "main";
        pull.rebase = true;
        color.ui = "auto";
      };
    };
  };
}
