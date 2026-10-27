{
  flake.homeModules.opencode =
    { config, pkgs, ... }:
    let
      c = config.lib.stylix.colors.withHashtag;
    in
    {
      home.packages = [ pkgs.opencode ];

      xdg.configFile = {
        "opencode/themes/stylix.json".text = builtins.toJSON {
          "$schema" = "https://opencode.ai/theme.json";
          name = "stylix";
          displayName = "Stylix";
          description = "Theme generated from Stylix colors";
          palette = {
            primary = c.base0D;
            secondary = c.base0E;
            accent = c.base0C;
            error = c.base08;
            warning = c.base0A;
            success = c.base0B;
            info = c.base0D;
          };
          colors = {
            background = c.base00;
            backgroundPanel = c.base01;
            backgroundElement = c.base02;
            border = c.base03;
            borderActive = c.base0D;
            borderSubtle = c.base02;
            text = c.base05;
            textMuted = c.base04;
            textSubtle = c.base03;
            primary = c.base0D;
            secondary = c.base0E;
            accent = c.base0C;
            error = c.base08;
            warning = c.base0A;
            success = c.base0B;
            info = c.base0D;
            diffAdded = c.base0B;
            diffRemoved = c.base08;
            diffContext = c.base04;
            diffHunkHeader = c.base0D;
            diffHighlightAdded = c.base0B;
            diffHighlightRemoved = c.base08;
          };
        };

        "opencode/config.json".text = builtins.toJSON {
          "$schema" = "https://opencode.ai/config.json";
          theme = "stylix";
          provider = {
            ollama = {
              npm = "@ai-sdk/openai-compatible";
              name = "Ollama (Local)";
              options = {
                baseURL = "http://127.0.0.1:11434/v1";
              };
              models = {
                "qwen2.5-coder:14b" = {
                  name = "Qwen 2.5 Coder 14B";
                };
              };
            };
          };
          model = "ollama/qwen2.5-coder:14b";
        };
      };
    };
}
