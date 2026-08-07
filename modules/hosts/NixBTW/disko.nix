{ inputs, ... }: {
  flake.nixosModules.disko-NixBTW = {
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
          device = "/dev/disk/by-id/nvme-CT2000T500SSD8_25094E70AC15";

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
                size = "8G";

                content = {
                  type = "swap";
                };
              };

              nix = {
                size = "100%";

                content = {
                  type = "filesystem";
                  format = "ext4";
                  mountpoint = "/nix";
                };
              };
            };
          };
        };

        preserve = {
          type = "disk";
          device = "/dev/disk/by-id/nvme-PCSPECIALIST_PCS3480_256GB_MQ16B75900699";

          content = {
            type = "gpt";

            partitions = {
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
