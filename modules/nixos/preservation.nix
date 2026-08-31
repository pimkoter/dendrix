{ inputs, ... }:
{
  flake.nixosModules.preservation = {
    imports = [ inputs.preservation.nixosModules.default ];

    # Disable Systemd warning for id-commit
    systemd.services.systemd-machine-id-commit.enable = false;

    preservation = {
      enable = true;
      preserveAt."/preserve" = {
        files = [
          {
            file = "/etc/machine-id";
            inInitrd = true;
          }
          {
            file = "/etc/ssh/ssh_host_ed25519_key";
            mode = "0600";
            inInitrd = true;
          }
          {
            file = "/etc/ssh/ssh_host_ed25519_key.pub";
            mode = "0644";
            inInitrd = true;
          }
          {
            file = "/etc/ssh/ssh_host_rsa_key";
            mode = "0600";
            inInitrd = true;
          }
          {
            file = "/etc/ssh/ssh_host_rsa_key.pub";
            mode = "0644";
            inInitrd = true;
          }
        ];

        directories = [
          "/var/lib/tailscale/"
          "/var/lib/systemd/timers"
          "/var/lib/howdy/models/"
          "/var/lib/nixos"
          "/var/lib/bluetooth"
          "/var/log"
          "/etc/NetworkManager/system-connections"
        ];
      };
    };
  };
}
