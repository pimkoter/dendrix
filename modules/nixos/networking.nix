{
  flake.nixosModules.networking = {
    networking = {
      networkmanager = {
        enable = true;
      };
      nameservers = [ "1.1.1.1" ];
      firewall = {
        enable = true;
      };
      hosts = {
        # "IPADDR" = [ "NAME" ];
      };
    };
  };
}
