{
  flake.homeModules.tmux = {
    config,
    lib,
    pkgs,
    ...
  }: let
    c = config.lib.stylix.colors.withHashtag;
  in {
    programs.tmux = {
      enable = true;
      clock24 = true;
      keyMode = "vi";
      terminal = "tmux-256color";
      shortcut = "a";
      shell = "${pkgs.zsh}/bin/zsh";
      baseIndex = 1;
      newSession = true;
      mouse = false;
      extraConfig = ''
        set -ga terminal-overrides ",*:RGB"
        set -g set-clipboard on
        set -g focus-events on

        unbind C-b
        set -g prefix C-a
        bind-key C-a send-prefix

        ##### Splits #####

        unbind %
        unbind '"'

        bind | split-window -h -c "#{pane_current_path}"
        bind - split-window -v -c "#{pane_current_path}"

        bind v split-window -h -c "#{pane_current_path}"
        bind s split-window -v -c "#{pane_current_path}"

        ##### Pane Navigation #####

        bind h select-pane -L
        bind j select-pane -D
        bind k select-pane -U
        bind l select-pane -R

        # alt+hjkl to switch panes without prefix
        bind -n M-h select-pane -L
        bind -n M-j select-pane -D
        bind -n M-k select-pane -U
        bind -n M-l select-pane -R

        ##### QOL configs #####

        set -g pane-base-index 1
        set-window-option -g pane-base-index 1
        set -g renumber-windows on

        # Shift + arrows to switch windows
        bind -n S-Left previous-window
        bind -n S-Right next-window

        # Alt + number to switch windows
        bind -n M-1 select-window -t 1
        bind -n M-2 select-window -t 2
        bind -n M-3 select-window -t 3
        bind -n M-4 select-window -t 4
        bind -n M-5 select-window -t 5
        bind -n M-6 select-window -t 6
        bind -n M-7 select-window -t 7
        bind -n M-8 select-window -t 8
        bind -n M-9 select-window -t 9
        bind -n M-0 select-window -t 10

        ##### Copy Mode #####

        bind-key -T copy-mode-vi v send-keys -X begin-selection
        bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
        bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

        unbind -T copy-mode-vi MouseDragEnd1Pane

        ##### Status bar settings #####

        set -g status "on"
        set -g status-bg "${c.base00}"
        set -g status-justify "centre" # Changed to centre so Neovim data can sit elegantly on the sides

        set -g status-left-length "1000"
        set -g status-right-length "1000"

        ##### Panes #####

        set -g pane-border-style "fg=${c.base02}"
        set -g pane-active-border-style "fg=${c.base0D}"

        ##### Windows #####

        set -g window-status-activity-style "fg=${c.base09},bg=${c.base00},none"
        set -g window-status-separator ""
        # Set the default window style background to base02 for the tab shape
        set -g window-status-style "fg=${c.base03},bg=${c.base02},none"

        ##### Messages #####

        set -g message-style "fg=${c.base05},bg=${c.base01},align=centre"
        set -g message-command-style "fg=${c.base05},bg=${c.base01},align=centre"

        ##### Status line current window #####

        set -g window-status-current-format "#[fg=${c.base00},bg=${c.base0D}] #I: #[fg=${c.base00},bg=${c.base0D}](✓) #[fg=${c.base00},bg=${c.base0D}]#(echo '#{pane_current_path}' | rev | cut -d'/' -f-2 | rev) #[fg=${c.base00},bg=${c.base0D}]"

        ##### Statusline - other windows #####

        # Using base02 here creates a beautiful, subtle dark-gray tab container
        set -g window-status-format "#[fg=${c.base03},bg=${c.base02}] #I: #[fg=${c.base03},bg=${c.base02}]#W #[fg=${c.base03},bg=${c.base02}]"

        ##### Statusline - Left & Right Side overrides #####
        set -g status-left ""
        set -g status-right "#[fg=${c.base05},bg=${c.base00}] #S "

        ##### Modes #####

        set -g clock-mode-colour "${c.base0D}"
        set -g mode-style "fg=${c.base00} bg=${c.base0D} bold"
      '';
    };
  };
}
