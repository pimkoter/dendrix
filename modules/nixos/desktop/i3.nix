{
  flake.nixosModules.i3 =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        kitty
        tmux
        rofi
        firefox
      ];

      services.xserver = {
        enable = true;
        windowManager.i3 = {
          enable = true;

          configFile = pkgs.writeText "i3-config" ''
            set $mod Mod4

            # Kitty + tmux
            bindsym $mod+T exec ${pkgs.kitty}/bin/kitty -e ${pkgs.tmux}/bin/tmux new-session -A -s main

            # Zen Browser
            bindsym $mod+B exec firefox

            # Rofi
            bindsym $mod+space exec ${pkgs.rofi}/bin/rofi -show drun

            # Kill focused window
            bindsym $mod+Q kill

            # Focus
            bindsym $mod+H focus left
            bindsym $mod+J focus down
            bindsym $mod+K focus up
            bindsym $mod+L focus right
          '';
        };
      };
    };
}
