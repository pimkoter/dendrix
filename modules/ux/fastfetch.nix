{
  self,
  inputs,
  ...
}: {
  flake.homeModules.fastfetch = {
    programs.fastfetch = {
      enable = true;

      settings = {
        schema = "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json";

        logo.padding.top = 2;
        display.separator = "  󰑃  ";

        modules = [
          "break"
          {
            type = "os";
            key = " DISTRO";
          }
          {
            type = "kernel";
            key = "│ ├";
          }
          {
            type = "uptime";
            key = "│ ├󱎫";
          }
          {
            type = "packages";
            key = "│ ├󰏖";
            format = "{1} ({10} sys, {11} usr)";
          }
          {
            type = "command";
            key = "│ ├";
            text = "install=$(stat -c %W /nix); now=$(date +%s); echo $(((now-install)/86400)) days";
          }
          {
            type = "shell";
            key = "│ └";
          }

          {
            type = "wm";
            key = " DE/WM";
          }
          {
            type = "wmtheme";
            key = "│ ├󰉼";
          }
          {
            type = "icons";
            key = "│ ├󰀻";
          }
          {
            type = "cursor";
            key = "│ ├";
          }
          {
            type = "terminalfont";
            key = "│ ├";
          }
          {
            type = "terminal";
            key = "│ └";
          }

          {
            type = "host";
            key = "󰌢 SYSTEM";
          }
          {
            type = "cpu";
            key = "  ├󰻠";
            format = "{1}";
          }
          {
            type = "gpu";
            key = "  ├󰻑";
            format = "{2}";
          }
          {
            type = "memory";
            key = "  ├󰾆";
          }
          {
            type = "localip"; # Added LocalIP
            key = "  └󰩟";
            showIpv4 = true;
            showIpv6 = false;
          }
        ];
      };
    };
  };
}
