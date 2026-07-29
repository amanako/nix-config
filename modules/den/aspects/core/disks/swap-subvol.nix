{lib, ...}: {
  den.aspects.core.disks.swap-subvol = {
    description = "Swap subvolume on btrfs root with a swapfile.";

    hostSettings = {
      swapSize = lib.mkOption {
        type = lib.types.str;
        default = "16G";
        description = "Size of the swapfile.";
      };
    };

    diskoConfig = {host, ...}: {
      subvolumes."/swap" = {
        mountpoint = "/swap";
        mountOptions = [
          "nodatacow"
        ];
        swap.swapfile.size = host.settings.core.disks.swap-subvol.swapSize;
      };
    };
  };
}
