{lib, ...}: {
  den.aspects.core.disks.rpi-boot = {
    description = "Boot partition for Raspberry Pi (FAT32, non-EFI).";

    hostSettings = {
      size = lib.mkOption {
        type = lib.types.str;
        default = "256M";
        example = "512M";
        description = "Size of the boot partition.";
      };
    };

    diskoConfig = {host, ...}: {
      partitions.BOOT = {
        priority = 1;
        name = "BOOT";
        start = "1M";
        end = host.settings.core.disks.rpi-boot.size;
        type = "0C01";
        content = {
          type = "filesystem";
          format = "vfat";
          mountpoint = "/boot";
          mountOptions = [
            "umask=0022"
          ];
        };
      };
    };
  };
}
