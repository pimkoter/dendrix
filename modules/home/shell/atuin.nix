{
  flake.homeModules.atuin = {
    programs.atuin = {
      enable = true;
      enableBashIntegration = true;
      forceOverwriteSettings = true;
      flags = [
        "--disable-up-arrow"
      ];
      settings = {
        auto_sync = false;
        search_mode = "fuzzy";
        style = "compact";
        show_preview = true;
      };
    };
  };
}
