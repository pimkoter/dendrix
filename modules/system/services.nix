{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.services = {
    services = {
      avahi = {
        enable = true;
        openFirewall = true; # <-- This opens the UDP port 5353 for mDNS discovery
      };
      printing = {
        enable = true;
      };
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
