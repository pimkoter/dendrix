{
  self,
  inputs,
  ...
}: {
  flake.homeModules.rofi = {
    pkgs,
    lib,
    inputs,
    ...
  }: {
    stylix.targets.rofi.enable = true;
    programs.rofi = {
      enable = true;
      extraConfig = {
        show-icons = true;
        icon-theme = "Papirus-Dark";
        modi = "drun";
        drun-display-format = "{name}";
        display-drun = "Launching: ";
        disable-history = false;
        sidebar-mode = false;
      };

      theme = let
        mkLiteral = value: {
          _type = "literal";
          inherit value;
        };
      in {
        "window" = {
          width = mkLiteral "680px";
          height = mkLiteral "680px";
          border = mkLiteral "2px";
          border-radius = mkLiteral "0px";
          padding = mkLiteral "20px";
        };

        "inputbar" = {
          children = map mkLiteral ["prompt" "entry"];
          margin = mkLiteral "0px 0px 20px 0px";
        };

        "listview" = {
          columns = 4;
          lines = 4;
          spacing = mkLiteral "15px";
          cycle = true;
          dynamic = true;
          layout = mkLiteral "vertical";
        };

        "element" = {
          orientation = mkLiteral "vertical";
          padding = mkLiteral "15px 10px";
          border-radius = mkLiteral "0px";
        };

        "element-icon" = {
          size = mkLiteral "64px";
          horizontal-align = mkLiteral "0.5";
        };

        "element-text" = {
          horizontal-align = mkLiteral "0.5";
          margin = mkLiteral "10px 0px 0px 0px";
        };
      };
    };
  };
}
