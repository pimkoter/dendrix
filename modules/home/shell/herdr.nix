{ inputs, ... }:
{
  flake.homeModules.herdr =
    { config, pkgs, ... }:
    let
      c = config.lib.stylix.colors.withHashtag;
    in
    {
      home.packages = [
        inputs.herdr.packages.${pkgs.stdenv.hostPlatform.system}.default
        pkgs.jq
      ];

      xdg.configFile."herdr/config.toml".text = ''
        onboarding = false

        [terminal]
        default_shell = "${pkgs.bash}/bin/bash"
        new_cwd = "follow"

        [keys]
        prefix = "ctrl+a"

        # Tabs
        new_tab = "prefix+c"

        # Pane splitting
        split_vertical = "prefix+v"
        split_horizontal = ["prefix+minus", "prefix+s"]

        # Pane navigation
        focus_pane_left = ["prefix+m", "alt+m"]
        focus_pane_down = ["prefix+n", "alt+n"]
        focus_pane_up = ["prefix+e", "alt+e"]
        focus_pane_right = ["prefix+i", "alt+i"]

        # Pane management
        zoom = "prefix+z"
        close_pane = "prefix+x"
        copy_mode = "prefix+a"

        # Workspace/session navigation
        workspace_picker = "prefix+f"
        goto = "prefix+w"

        [keys.indexed]
        tabs = "alt"

        [ui]
        mouse_capture = false

        pane_borders = "auto"
        pane_outer_borders = false
        pane_gaps = false
        pane_scrollbars = false

        hide_tab_bar_when_single_tab = false
        tab_bar_position = "top"

        # Current working directory + 24-hour clock.
        tab_bar_right = [
          { type = "command", command = "printf '%s\n' \"$HERDR_ACTIVE_PANE_CWD\" | awk -F/ '{print $(NF-1) \"/\" $NF}'", interval_seconds = 2, timeout_seconds = 1 },
          { type = "datetime", format = "%H:%M" },
          { type = "zoom" },
        ]
        tab_bar_right_separator = " "

        window_title = "{workspace}: {tab}"

        # Reuse your Stylix palette.
        accent = "${c.base0D}"

        [theme]
        name = "terminal"

        [theme.custom]
        accent = "${c.base0D}"
        panel_bg = "${c.base00}"
        sidebar_bg = "${c.base00}"
        active_row_bg = "${c.base0D}"
        selection_bg = "${c.base02}"

        surface0 = "${c.base02}"
        surface1 = "${c.base01}"
        surface_dim = "${c.base01}"

        overlay0 = "${c.base03}"
        overlay1 = "${c.base04}"

        text = "${c.base05}"
        subtext0 = "${c.base04}"

        blue = "${c.base0D}"
        mauve = "${c.base0E}"
        green = "${c.base0B}"
        yellow = "${c.base0A}"
        red = "${c.base08}"
        teal = "${c.base0C}"
        peach = "${c.base09}"

        [session]
        resume_agents_on_restore = true

        [[keys.command]]
        key = "alt+0"
        type = "shell"
        command = "tab_id=\"$(herdr tab list --workspace \"$HERDR_ACTIVE_WORKSPACE_ID\" | jq -r '.result.tabs[9].tab_id // empty')\"; [ -n \"$tab_id\" ] && herdr tab focus \"$tab_id\""
        description = "switch to tab 10"
      '';
    };
}
