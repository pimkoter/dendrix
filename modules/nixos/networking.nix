{
  flake.nixosModules.networking = { lib, ... }: {
    networking = {
      hostName =
        let
          hostname = builtins.getEnv "HOSTNAME";
        in
        if hostname != "" then hostname else "nixos";
      networkmanager = {
        enable = true;
      };
      firewall = {
        enable = true;
      };
      hosts = {
        # "IPADDR" = [ "NAME" ];
      };
    };
  };
}
