{ den, inputs, ... }:

{
  den.aspects.nebula._.hardware = {
    includes = [
      den.aspects.hardware
      den.aspects.hardware._.with-disko
    ];

    nixos =
      {
        pkgs,
        lib,
        modulesPath,
        ...
      }:
      {
        # Without adding this modulesPath AMD and bluetooth service fail to start
        # With message hardware initialization failed
        # EDIT: After adding facter.json report below it seems OK to remove this line
        # Anyhow, you may wish to uncomment in case of hardware failure (and above)
        # imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];
        hardware.facter.reportPath = ./facter.json;

        boot.initrd.availableKernelModules = [
          "nvme"
          "xhci_pci"
        ];

        # I like to use zen packages buy it may be changed
        boot.kernelPackages = pkgs.linuxPackages_latest;

        boot.initrd.kernelModules = [ ];
        boot.kernelModules = [ "kvm-amd" ];
        boot.extraModulePackages = [ ];

        boot.supportedFilesystems = [
          "btrfs"
          "ext4"
          "fat"
          "vfat"
          "exfat"
        ];

        disko.devices = {
          disk = {
            main = {
              type = "disk";
              device = "/dev/disk/by-id/nvme-eui.002538d321454dfa";
              content = {
                type = "gpt";
                partitions = {
                  ESP = {
                    priority = 1;
                    name = "ESP";
                    start = "1M";
                    end = "512M";
                    type = "EF00";
                    content = {
                      type = "filesystem";
                      format = "vfat";
                      mountpoint = "/boot";
                      mountOptions = [ "umask=0077" ];
                    };
                  };
                  root = {
                    size = "100%";
                    content = {
                      type = "btrfs";
                      extraArgs = [ "-f" ]; # Override existing partition
                      # Subvolumes must set a mountpoint in order to be mounted,
                      # unless their parent is mounted
                      subvolumes = {
                        # Subvolume name is different from mountpoint
                        "/rootfs" = {
                          mountpoint = "/";
                        };
                        # Subvolume name is the same as the mountpoint
                        "/home" = {
                          mountOptions = [ "compress=zstd" ];
                          mountpoint = "/home";
                        };
                        # Parent is not mounted so the mountpoint must be set
                        "/nix" = {
                          mountOptions = [
                            "compress=zstd"
                            "noatime"
                          ];
                          mountpoint = "/nix";
                        };
                        # This subvolume will be created but not mounted
                        "/test" = { };
                        # Subvolume for the swapfile
                        "/swap" = {
                          mountpoint = "/.swapvol";
                          swap.swapfile.size = "16G";
                        };
                      };

                      mountpoint = "/partition-root";
                      swap = {
                        swapfile = {
                          size = "20M";
                        };
                        swapfile1 = {
                          size = "20M";
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
  };
}
