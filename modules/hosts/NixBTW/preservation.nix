{ inputs, ... }:
{
  flake.nixosModules.preservation-NixBTW = {
    imports = [ inputs.preservation.nixosModules.default ];
    preservation = {
      enable = true;
      preserveAt."/preserve" = {
        files = [
          {
            file = "/etc/machine-id";
            inInitrd = true;
          }
          "/etc/ssh/ssh_host_ed25519_key"
          "/etc/ssh/ssh_host_ed25519_key.pub"
          "/etc/ssh/ssh_host_rsa_key"
          "/etc/ssh/ssh_host_rsa_key.pub"
        ];

        directories = [
          "/var/lib/systemd/timers"
          "/var/lib/nixos"
          "/var/log"
          "/var/lib/bluetooth"
          "/etc/NetworkManager/system-connections"
        ];

        users.pim = {
          directories = [
            "Downloads"
            "Pictures"
            "Backups"
            "Notes"
            "Projects"
            "Repos"
            "Games"
          ]
          ++ [ ".ssh" ];
        };
      };
    };
  };
}
