{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.services = {
    services = {
      openssh.enable = true;
      upower.enable = true;
      xserver.xkb = {
        layout = "us";
      };
      blueman.enable = true;
      tailscale = {
        enable = true;
        extraUpFlags = [
          "--netfilter-mode=nodivert"
          "--no-logs-no-support"
        ];
      };
      fail2ban = {
        enable = true;
        bantime = "10m";
        bantime-increment.factor = "6";
      };
    };
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };
}
