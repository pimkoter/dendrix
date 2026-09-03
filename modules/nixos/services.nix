{
  flake.nixosModules.services = { pkgs, ... }: {
    services = {
      resolved = {
        enable = true;
        settings.Resolve = {
          DNSSEC = "true";
          Domains = [ "~." ];
          DNSOverTLS = "true";
          FallbackDNS = [
            "1.1.1.1"
            "1.0.0.1"
          ];
        };
      };
      avahi = {
        enable = true;
        openFirewall = true;
      };
      printing.enable = true;
      openssh.enable = true;
      upower.enable = true;
      xserver.xkb.layout = "us";
      blueman.enable = true;
      tailscale = {
        enable = true;
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
