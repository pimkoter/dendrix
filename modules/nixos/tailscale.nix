{
  flake.nixosModules.tailscale = { config, ... }: {
    services.tailscale = {
      enable = true;
      authKeyFile = config.sops.secrets."tailscale".path;
      useRoutingFeatures = "client";
      extraUpFlags = [
        "--accept-router"
        "--exit-node=auto:any"
        "--timeout=30s"
      ];
    };

    networking.firewall = {
      trustedInterfaces = [ config.services.tailscale.interfaceName ];
      allowedUDPPorts = [ config.services.tailscale.port ];
    };
  };
}
