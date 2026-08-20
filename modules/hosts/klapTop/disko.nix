{ inputs, ... }: {
  flake.nixosModules.disko-klapTop = {
    imports = [ inputs.disko.nixosModules.disko ];

    fileSystems."/nix".neededForBoot = true;
    fileSystems."/preserve".neededForBoot = true;

    disko.devices = {
      nodev = {
        "/" = {
          fsType = "tmpfs";
          mountOptions = [
            "size=25%"
            "mode=755"
          ];
        };
      };

      disk = {
        system = {
          type = "disk";
          device = "/dev/disk/by-id/nvme-KBG30ZMV256G_TOSHIBA_199PC7NHPZXP";

          content = {
            type = "gpt";

            partitions = {
              ESP = {
                size = "1G";
                type = "EF00";

                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
                  mountOptions = [
                    "fmask=0077"
                    "dmask=0077"
                  ];
                };
              };

              swap = {
                size = "4G";

                content = {
                  type = "swap";
                };
              };

              nix = {
                size = "100G";

                content = {
                  type = "filesystem";
                  format = "ext4";
                  mountpoint = "/nix";
                };
              };

              preserve = {
                size = "100%";

                content = {
                  type = "filesystem";
                  format = "ext4";
                  mountpoint = "/preserve";
                };
              };
            };
          };
        };
      };
    };
  };
}
