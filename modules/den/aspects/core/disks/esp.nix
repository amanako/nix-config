{lib, ...}: {
  den.aspects.core.disks.esp = {
    description = "EFI System Partition for UEFI boot.";

    hostSettings = {
      size = lib.mkOption {
        type = lib.types.str;
        default = "4G";
        example = "2G";
        description = "Size of the ESP partition.";
      };
    };

    diskoConfig = {host, ...}: {
      partitions.ESP = {
        priority = 1;
        name = "ESP";
        start = "1M";
        end = host.settings.core.disks.esp.size;
        type = "EF00";
        content = {
          type = "filesystem";
          format = "vfat";
          mountpoint = "/boot";
          mountOptions = [
            "umask=0077"
          ];
        };
      };
    };
  };
}
