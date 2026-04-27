{
  den.hosts.x86_64-linux.nebula = {
    deviceType = "laptop";
    timeZone = "Europe/Belgrade";
    batteryID = "BAT1";

    gpus = [
      {
        type = "nvidia";
        busId = "PCI:0@1:0:0";
      }
      {
        type = "amd";
        busId = "PCI:0@5:0:0";
      }
    ];

    # Changing default directory implicitly enables module
    impermanence.persistenceDir = "/persist";

    users = {
      lunar-scar.classes = ["homeManager"];
    };

    disko.devices = {
      disk = {
        main = {
          type = "disk";
          device = "/dev/disk/by-id/nvme-SAMSUNG_MZVLQ512HBLU-00B00_S6F5NS0T325504";
          content = {
            type = "gpt";
            partitions = {
              ESP = {
                priority = 1;
                name = "ESP";
                start = "1M";
                # Better to be generous in case
                end = "2G";
                type = "EF00";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
                  mountOptions = ["umask=0077"];
                };
              };
              root = {
                size = "100%";
                content = {
                  type = "btrfs";
                  extraArgs = ["-f"]; # Override existing partition
                  subvolumes = {
                    "/root" = {
                      mountpoint = "/";
                      mountOptions = [
                        "compress=zstd"
                        "noatime"
                      ];
                    };
                    # nix-store
                    "/nix" = {
                      mountOptions = [
                        "compress=zstd"
                        "noatime"
                      ];
                      mountpoint = "/nix";
                    };
                    "/persist" = {
                      mountpoint = "/persist";
                      mountOptions = [
                        "compress=zstd"
                        "noatime"
                      ];
                    };
                    "/swap" = {
                      mountpoint = "/swap";
                      swap.swapfile.size = "16G";
                      mountOptions = ["nodatacow"];
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
