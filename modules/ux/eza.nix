{
  self,
  inputs,
  ...
}: {
  flake.homeModules.eza = {
    programs.eza = {
      enable = true;
      icons = "auto";
      enableZshIntegration = true;
      git = true;

      extraOptions = [
        "--group-directories-first"
        "--no-quotes"
        "--header"
        "--git-ignore"
        "--icons=always"
        "--classify"
        "--hyperlink"
      ];
    };
  };
}
