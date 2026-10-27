{lib, ...}: {
  den.aspects.core.disks.rpi-boot = {
    description = "Boot partition for Raspberry Pi (FAT32, non-EFI).";

    hostSettings = {
      size = lib.mkOption {
        type = lib.types.str;
        default = "512M";
        example = "1G";
        description = "Size of the boot partition.";
      };
    };

    diskoConfig = {host, ...}: {
      partitions.boot = {
        priority = 1;
        name = "boot";
        start = "1M";
        end = host.settings.core.disks.rpi-boot.size;
        type = "EF00";
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
