{
  self,
  inputs,
  ...
}: {
  flake.homeModules.git = {config, ...}: let
    name = "pim";
    mail = "koter";
  in {
    programs.git = {
      enable = true;
      settings = {
        user.name = name;
        user.email = "${name}@${mail}";
        init.defaultBranch = "main";
        pull.rebase = true;
        color.ui = "auto";
      };
    };
  };
}
