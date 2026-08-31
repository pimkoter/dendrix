{ inputs, ... }: {
  flake.nixosModules.disko-klapTop = {
    imports = [ inputs.disko.nixosModules.disko ];

    disko.devices = {
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
                size = "8G";

                content = {
                  type = "swap";
                };
              };

              root = {
                size = "100%";

                content = {
                  type = "filesystem";
                  format = "ext4";
                  mountpoint = "/";
                };
              };
            };
          };
        };
      };
    };
  };
}
