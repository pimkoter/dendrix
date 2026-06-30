{
  self,
  inputs,
  ...
}: {
  flake.homeModules.bat = {
    pkgs,
    lib,
    ...
  } @ args: {
    programs.bat = {
      enable = true;
      config = {
        pager = "less -FR";
        style = "full";
        theme = lib.mkForce "Dracula";
      };
      extraPackages = with args.pkgs.bat-extras; [
        batman
        batpipe
      ];
    };
    home.sessionVariables = {
      MANPAGER = "sh -c 'col -bx | bat -l man -p '";
      MANROFFOPT = "-c";
    };
  };
}
