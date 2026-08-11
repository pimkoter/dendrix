{ inputs, ... }:
{
  flake.nixosModules.preservation-NixBTW = {
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
            ".config/zen"
            ".local/share/xonsh/history_json"
            ".local/share/zoxide"
          ]
          ++ [ ".ssh" ];
        };
      };
    };
  };
}
