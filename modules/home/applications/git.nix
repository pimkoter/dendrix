{
  flake.homeModules.git =
    { config, ... }:
    {
      sops = {
        secrets = {
          "personal/git/user" = { };
          "personal/git/email" = { };
        };

        templates."git-config".content = ''
          [user]
            name = "${config.sops.placeholder."personal/git/user"}"
            email = "${config.sops.placeholder."personal/git/email"}"
        '';
      };

      programs.git = {
        enable = true;
        extraConfig = {
          include.path = config.sops.templates."git-config".path;
          init.defaultBranch = "main";
          pull.rebase = true;
          color.ui = "auto";
        };
      };
    };
}
