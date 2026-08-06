{
  flake.nixosModules.networking = { lib, ... }: {
    networking = {
      hostName = lib.mkDefault builtins.getEnv "HOSTNAME";
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
