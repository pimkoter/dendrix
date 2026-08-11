{
  flake.nixosModules.networking = { lib, ... }: {
    networking = {
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
