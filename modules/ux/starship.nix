{
  self,
  inputs,
  ...
}: {
  flake.homeModules.starship = {
    config,
    lib,
    ...
  } @ args: let
    c = config.stylix.base16Scheme;
  in {
    programs.starship = {
      enable = true;
      settings = {
        format = lib.concatStrings [
          "[](#${c.base01})"
          "$python$os"
          "[](bg:#${c.base02} fg:#${c.base01})"
          "$directory"
          "[](fg:#${c.base02} bg:#${c.base03})"
          "$git_branch$git_status"
          "[](fg:#${c.base03} bg:#${c.base0D})"
          "$clanguage$elixir$elm$golang$haskell$java$julia$nodejs$nim$rust"
          "[](fg:#${c.base0D} bg:#${c.base0C})"
          "$docker_context"
          "[](fg:#${c.base0C} bg:#${c.base0A})"
          "$time"
          "[](fg:#${c.base0A})"
          "  "
        ];

        command_timeout = 5000;

        username = {
          show_always = true;
          style_user = "bg:#${c.base01}";
          style_root = "bg:#${c.base01}";
          format = "[$user ]($style)";
        };

        directory = {
          style = "bg:#${c.base02}";
          format = "[ $path ]($style)";
          truncation_length = 3;
          truncation_symbol = "…/";
          substitutions = {
            Documents = "󰈙 ";
            Downloads = " ";
            Music = " ";
            Pictures = " ";
          };
        };

        git_branch = {
          symbol = "";
          style = "bg:#${c.base03}";
          format = "[ $symbol $branch ]($style)";
        };

        git_status = {
          style = "bg:#${c.base03}";
          format = "[$all_status$ahead_behind ]($style)";
        };

        python = {
          style = "bg:#${c.base01}";
          format = "[($virtualenv )]($style)";
        };

        time = {
          disabled = false;
          time_format = "%R";
          style = "bg:#${c.base0A}";
          format = "[ $time ]($style)";
        };

        c = {
          symbol = " ";
          style = "bg:#${c.base0D}";
          format = "[ $symbol ($version) ]($style)";
        };

        rust = {
          symbol = "";
          style = "bg:#${c.base0D}";
          format = "[ $symbol ($version) ]($style)";
        };

        nodejs = {
          symbol = "";
          style = "bg:#${c.base0D}";
          format = "[ $symbol ($version) ]($style)";
        };
      };
    };
  };
}
