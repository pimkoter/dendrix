{

  flake.nixosModules.mangowc = { pkgs, ... }: {
    # MangoWC itself is currently better treated as a package/session
    # than as a programs.mango option.
    environment.systemPackages = [
      pkgs.mangowc
    ];
  };

  flake.homeModules.mangowc =
    { config, pkgs, ... }:
    let
      colors = config.stylix.base16Scheme;

      monitors = {
        left = "DP-4";
        middle = "DP-5";
        right = "eDP-1";
      };
    in
    {
      xdg.configFile."mango/config.conf" = {
        force = true;

        text = ''
          # =====================
          # STARTUP
          # =====================

          exec-once=noctalia-shell

          # =====================
          # ENVIRONMENT
          # =====================

          env=QT_QPA_PLATFORM,wayland
          env=ELECTRON_OZONE_PLATFORM_HINT,auto
          env=QT_QPA_PLATFORMTHEME,kvantum
          env=QT_STYLE_OVERRIDE,kvantum
          env=TERMINAL,kitty
          env=XCURSOR_THEME,Bibata-Modern-Ice
          env=XCURSOR_SIZE,24


          # =====================
          # GENERAL
          # =====================

          # 9px gaps, matching niri
          gappih=9
          gappiv=9
          gappoh=9
          gappov=9


          # =====================
          # APPEARANCE
          # =====================

          borderpx=2

          rootcolor=0x${colors.base00}ff

          bordercolor=0x${colors.base03}ff
          focuscolor=0x${colors.base0D}ff
          urgentcolor=0x${colors.base08}ff

          dropcolor=0x${colors.base09}88
          splitcolor=0x${colors.base0E}ff
          maximizescreencolor=0x${colors.base0C}ff

          scratchpadcolor=0x${colors.base0B}ff
          globalcolor=0x${colors.base0A}ff
          overlaycolor=0x${colors.base0D}ff

          # =====================
          # MONITORS
          # =====================

          monitorrule=name:${monitors.left},transform:0,scale:1,x:0,y:0,width:1920,height:1080,rr:60
          monitorrule=name:${monitors.middle},transform:0,scale:1,x:1920,y:0,width:1920,height:1080,rr:165
          monitorrule=name:${monitors.right},transform:0,scale:1.5,x:3840,y:0,width:2560,height:1600,rr:60

          # =====================
          # TAGS
          # =====================

          # Keep tags persistent so they behave more like
          # your numbered niri workspaces.

          tagrule=id:1,no_hide:1,layout_name:scroller
          tagrule=id:2,no_hide:1,layout_name:scroller
          tagrule=id:3,no_hide:1,layout_name:scroller
          tagrule=id:4,no_hide:1,layout_name:scroller
          tagrule=id:5,no_hide:1,layout_name:scroller
          tagrule=id:6,no_hide:1,layout_name:scroller
          tagrule=id:7,no_hide:1,layout_name:scroller
          tagrule=id:8,no_hide:1,layout_name:scroller
          tagrule=id:9,no_hide:1,layout_name:scroller


          # =====================
          # APPLICATIONS
          # =====================

          bind=SUPER,SPACE,spawn,rofi -show drun
          bind=SUPER,Y,spawn,rofi-bookmarks
          bind=SUPER,G,spawn,rofi-repos
          bind=SUPER,V,spawn,rofi-wallpaper
          bind=SUPER,N,spawn,nix
          bind=SUPER,T,spawn,kitty
          bind=SUPER,B,spawn,zen
          bind=SUPER+SHIFT,M,spawn,pavucontrol


          # =====================
          # MEDIA / VOLUME
          # =====================

          bindl=NONE,XF86AudioRaiseVolume,spawn,wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+ -l 1.0
          bindl=NONE,XF86AudioLowerVolume,spawn,wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-
          bindl=NONE,XF86AudioMute,spawn,wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
          bindl=NONE,XF86AudioMicMute,spawn,wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle

          bindl=NONE,XF86AudioPlay,spawn,playerctl play-pause
          bindl=NONE,XF86AudioStop,spawn,playerctl stop
          bindl=NONE,XF86AudioPrev,spawn,playerctl previous
          bindl=NONE,XF86AudioNext,spawn,playerctl next


          # =====================
          # BRIGHTNESS
          # =====================

          bindl=NONE,XF86MonBrightnessUp,spawn,brightnessctl --class=backlight set +10%
          bindl=NONE,XF86MonBrightnessDown,spawn,brightnessctl --class=backlight set 10%-


          # =====================
          # WINDOW MANAGEMENT
          # =====================

          # Close
          bind=SUPER,Q,killclient

          # Overview
          bind=SUPER,X,toggleoverview


          # =====================
          # FOCUS
          # =====================

          # A/D
          bind=SUPER,A,focusdir,left
          bind=SUPER,D,focusdir,right

          # H/J/K/L
          bind=SUPER,H,focusdir,left
          bind=SUPER,J,focusdir,down
          bind=SUPER,K,focusdir,up
          bind=SUPER,L,focusdir,right

          # Arrows
          bind=SUPER,LEFT,focusdir,left
          bind=SUPER,RIGHT,focusdir,right
          bind=SUPER,UP,focusdir,up
          bind=SUPER,DOWN,focusdir,down


          # =====================
          # MOVE WINDOWS
          # =====================

          bind=SUPER+CTRL,A,movewin,left
          bind=SUPER+CTRL,D,movewin,right

          bind=SUPER+CTRL,H,movewin,left
          bind=SUPER+CTRL,L,movewin,right


          # =====================
          # MONITOR FOCUS
          # =====================

          bind=SUPER+SHIFT,A,focusmon,left
          bind=SUPER+SHIFT,D,focusmon,right

          bind=SUPER+SHIFT,H,focusmon,left
          bind=SUPER+SHIFT,L,focusmon,right


          # =====================
          # MOVE TO MONITOR
          # =====================

          bind=SUPER+SHIFT+CTRL,A,tagmon,left,1
          bind=SUPER+SHIFT+CTRL,D,tagmon,right,1

          bind=SUPER+SHIFT+CTRL,H,tagmon,left,1
          bind=SUPER+SHIFT+CTRL,L,tagmon,right,1


          # =====================
          # TAGS / WORKSPACES
          # =====================

          # 1-9

          bind=SUPER,1,view,1
          bind=SUPER,2,view,2
          bind=SUPER,3,view,3
          bind=SUPER,4,view,4
          bind=SUPER,5,view,5
          bind=SUPER,6,view,6
          bind=SUPER,7,view,7
          bind=SUPER,8,view,8
          bind=SUPER,9,view,9


          # Move current window to tag

          bind=SUPER+CTRL,1,tag,1
          bind=SUPER+CTRL,2,tag,2
          bind=SUPER+CTRL,3,tag,3
          bind=SUPER+CTRL,4,tag,4
          bind=SUPER+CTRL,5,tag,5
          bind=SUPER+CTRL,6,tag,6
          bind=SUPER+CTRL,7,tag,7
          bind=SUPER+CTRL,8,tag,8
          bind=SUPER+CTRL,9,tag,9


          # Previous / next tag

          bind=SUPER+SHIFT,J,viewtoleft
          bind=SUPER+SHIFT,K,viewtoright


          # Move window to previous / next tag

          bind=SUPER+CTRL,J,tagtoleft
          bind=SUPER+CTRL,K,tagtoright


          # =====================
          # LAYOUT
          # =====================

          # Cycle layouts
          bind=SUPER,R,switch_layout

          # Master size
          bind=SUPER,MINUS,setmfact,-0.05
          bind=SUPER,EQUAL,setmfact,+0.05

          # Number of master windows
          bind=SUPER+CTRL,R,incnmaster,+1

          # Gaps
          bind=SUPER+ALT,MINUS,incgaps,-1
          bind=SUPER+ALT,EQUAL,incgaps,+1


          # =====================
          # MAXIMIZE / FULLSCREEN
          # =====================

          bind=SUPER+SHIFT,F,togglemaximizescreen
          bind=SUPER+CTRL,F,togglefullscreen


          # =====================
          # CENTER
          # =====================

          bind=SUPER,C,centerwin


          # =====================
          # SCREENSHOTS
          # =====================

          bind=SUPER+SHIFT,P,spawn,grim -g "$(slurp)" - | wl-copy
          bind=CTRL,P,spawn,grim - | wl-copy
          bind=ALT,P,spawn,grim -g "$(slurp)" - | wl-copy


          # =====================
          # CONFIG
          # =====================

          bind=SUPER+SHIFT,R,reload_config


          # =====================
          # MINECRAFT
          # =====================

          windowrule=isfullscreen:1,appid:Minecraft
          windowrule=width:1920,height:1080,appid:Minecraft
        '';
      };
    };
}
