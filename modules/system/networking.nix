{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.networking = {
    networking = {
      hostName = "NixBTW";
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
