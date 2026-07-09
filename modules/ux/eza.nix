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
        "--icons=always"
        "--classify"
        "--hyperlink"
      ];
    };
  };
}
