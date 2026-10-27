{lib, ...}: {
  den.aspects.core.disks.swap = {
    description = "Swap subvolume on btrfs root with a swapfile.";

    hostSettings = {
      size = lib.mkOption {
        type = lib.types.str;
        example = "8G";
        description = ''
          Size of the swapfile. Based on usage, recommended: from 1 to 2 times of RAM size.
          For usage with hibernation at least a little above 1. About 1.5 times the RAM size will be more than enough.
        '';
      };
    };

    diskoConfig = {host, ...}: {
      subvolumes."/swap" = {
        mountpoint = "/swap";
        mountOptions = [
          "nodatacow"
        ];
        swap.swapfile.size = host.settings.core.disks.swap.size;
      };
    };
  };
}
