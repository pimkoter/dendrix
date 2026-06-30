{
  self,
  inputs,
  ...
}: {
  flake.homeModules.niri = {config, ...} @ args: let
    colors = config.stylix.base16Scheme;
    monitors = {
      left = "DP-4";
      middle = "DP-5";
      right = "eDP-1";
    };
  in {
    xdg.configFile."niri/config.kdl" = {
      force = true;
      text = ''

      // =====================
      // STARTUP APPS
      // =====================
      spawn-at-startup "noctalia-shell"
      spawn-at-startup "spotify"
      spawn-at-startup "legcord"
      spawn-at-startup "steam"

      // =====================
      // KEYBINDS
      // =====================
      binds {

          Mod+Shift+Slash { show-hotkey-overlay; }

          // --- Applications ---
          Mod+Space   cooldown-ms=200            { spawn-sh "noctalia-shell ipc call launcher toggle"; }
          Mod+T        cooldown-ms=200            { spawn "kitty"; }
          Mod+D        cooldown-ms=200            { spawn "legcord"; }
          Mod+B        cooldown-ms=200            { spawn "helium"; }
          Mod+Shift+M  cooldown-ms=200            { spawn "pavucontrol"; }

          // --- Media / Volume ---
          XF86AudioRaiseVolume allow-when-locked=true { spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+ -l 1.0"; }
          XF86AudioLowerVolume allow-when-locked=true { spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-"; }
          XF86AudioMute allow-when-locked=true { spawn-sh "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"; }
          XF86AudioMicMute allow-when-locked=true { spawn-sh "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"; }
          XF86AudioPlay allow-when-locked=true { spawn-sh "playerctl play-pause"; }
          XF86AudioStop allow-when-locked=true { spawn-sh "playerctl stop"; }
          XF86AudioPrev allow-when-locked=true { spawn-sh "playerctl previous"; }
          XF86AudioNext allow-when-locked=true { spawn-sh "playerctl next"; }

          // --- Brightness ---
          XF86MonBrightnessUp allow-when-locked=true { spawn "brightnessctl" "--class=backlight" "set" "+10%"; }
          XF86MonBrightnessDown allow-when-locked=true { spawn "brightnessctl" "--class=backlight" "set" "10%-"; }

          // --- Window / Column Navigation ---
          Mod+Q repeat=false { close-window; }
          Mod+X repeat=false { toggle-overview; }

          Mod+A { focus-column-left; }
          Mod+S { focus-workspace-down; }
          Mod+W { focus-workspace-up; }
          Mod+Right { focus-column-right; } // Fixed the lowercase 'mod+D' conflict/typo here

          Mod+H { focus-column-left; }
          Mod+J { focus-workspace-down; }
          Mod+K { focus-workspace-up; }
          Mod+L { focus-column-right; }

          Mod+Left  { focus-column-left; }
          Mod+Down  { focus-workspace-down; }
          Mod+Up    { focus-workspace-up; }

          // --- Move Windows / Columns ---
          Mod+Ctrl+A { move-column-left; }
          Mod+Ctrl+D { move-column-right; }

          Mod+Ctrl+H { move-column-left; }
          Mod+Ctrl+L { move-column-right; }

          Mod+Ctrl+Left  { move-column-left; }
          Mod+Ctrl+Right { move-column-right; }

          // --- Monitor Focus ---
          Mod+Shift+A { focus-monitor-left; }
          Mod+Shift+D { focus-monitor-right; }

          Mod+Shift+H { focus-monitor-left; }
          Mod+Shift+L { focus-monitor-right; }

          Mod+Shift+Ctrl+A { move-column-to-monitor-left; }
          Mod+Shift+Ctrl+D { move-column-to-monitor-right; }

          Mod+Shift+Ctrl+H { move-column-to-monitor-left; }
          Mod+Shift+Ctrl+L { move-column-to-monitor-right; }

          // --- Workspaces ---
          Mod+Shift+S { focus-workspace-down; }
          Mod+Shift+W { focus-workspace-up; }

          Mod+Shift+J { focus-workspace-down; }
          Mod+Shift+K { focus-workspace-up; }

          Mod+Ctrl+S { move-column-to-workspace-down; }
          Mod+Ctrl+W { move-column-to-workspace-up; }

          Mod+Ctrl+J { move-column-to-workspace-down; }
          Mod+Ctrl+K { move-column-to-workspace-up; }

          // Workspace numbers
          Mod+1 { focus-workspace 1; }
          Mod+2 { focus-workspace 2; }
          Mod+3 { focus-workspace 3; }
          Mod+4 { focus-workspace 4; }
          Mod+5 { focus-workspace 5; }
          Mod+6 { focus-workspace 6; }
          Mod+7 { focus-workspace 7; }
          Mod+8 { focus-workspace 8; }
          Mod+9 { focus-workspace 9; }
          Mod+Ctrl+1 { move-column-to-workspace 1; }
          Mod+Ctrl+2 { move-column-to-workspace 2; }
          Mod+Ctrl+3 { move-column-to-workspace 3; }
          Mod+Ctrl+4 { move-column-to-workspace 4; }
          Mod+Ctrl+5 { move-column-to-workspace 5; }
          Mod+Ctrl+6 { move-column-to-workspace 6; }
          Mod+Ctrl+7 { move-column-to-workspace 7; }
          Mod+Ctrl+8 { move-column-to-workspace 8; }
          Mod+Ctrl+9 { move-column-to-workspace 9; }

          // --- Column Layout ---
          Mod+R        { switch-preset-column-width; }
          Mod+Ctrl+R   { reset-window-height; }

          Mod+Minus { set-column-width "-10%"; }
          Mod+Equal { set-column-width "+10%"; }

          Mod+Shift+Minus { set-window-height "-10%"; }
          Mod+Shift+Equal { set-window-height "+10%"; }

          Mod+Shift+F  { maximize-column; }
          Mod+Control+F { fullscreen-window; }

          Mod+C      { center-column; }
          Mod+Alt+C  { center-visible-columns; }

          // --- Screenshots ---
          Mod+Shift+P { screenshot; }
          Ctrl+P  { screenshot-screen; }
          Alt+P   { screenshot-window; }
      }

      // ENVIRONMENT
      // =====================
      hotkey-overlay {
          skip-at-startup
      }

      environment {
          QT_QPA_PLATFORM "wayland"
          ELECTRON_OZONE_PLATFORM_HINT "auto"
          QT_QPA_PLATFORMTHEME "kvantum"
          QT_STYLE_OVERRIDE "kvantum"
          TERMINAL "kitty"
          XCURSOR_THEME "Bibata-Modern-Ice"
          XCURSOR_SIZE "24"
      }

      // =====================
      // Gestures
      // =====================
      gestures {
        hot-corners {
          off
        }
      }

      // =====================
      // INPUT
      // =====================
      input {
          keyboard {
              xkb {}
              numlock
          }

          touchpad {
              tap
              natural-scroll
          }

          mouse {}
          trackpoint {}

          focus-follows-mouse max-scroll-amount="0%"
      }

      // =====================
      // LAYOUT
      // =====================
      layout {
          gaps 9
          center-focused-column "on-overflow"
          always-center-single-column

          preset-column-widths {
              proportion 0.33333
              proportion 0.5
              proportion 1.0
          }

          default-column-width { proportion 0.5; }

          focus-ring {
              off
          }

          border {
              width 2
              active-color "#${colors.base0D}"
              inactive-color "#${colors.base03}"
              urgent-color "#${colors.base08}"
          }

          struts {}
      }

      // =====================
      // OUTPUTS
      // =====================
      output "${monitors.left}" {
          mode "1920x1080@60"
          position x=0    y=0
      }

      output "${monitors.middle}" {
          mode "1920x1080@164.999"
          position x=1920 y=0
      }

      output "${monitors.right}" {
          mode "2560x1080@60"
          scale 1.5
          position x=3840 y=0
      }

      // =====================
      // WINDOW RULES
      // =====================

      prefer-no-csd true

      window-rule {
          match app-id="Minecraft"
          open-fullscreen true
          max-width 1920
          max-height 1080
      }
    '';
    };
  };
}
