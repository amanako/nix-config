{
  den.hosts.aarch64-linux.pi4 = {
    settings = {
      basic.time.timeZone = "Europe/Belgrade";

      core = {
        disks = {
          disko-collector.devicePath = "/dev/sda";

          swap-subvol.swapSize = "4G";
        };

        impermanence = {
          btrfs.disk-partition = "/dev/mmcblk0p2";
          mountHomeDir = false;
        };
      };

      core.hardware.raspberry-pi = {
        board = "raspberry-pi-4";
        enableVc4 = true;
        enableUsbGadget = true;
      };
    };
  };
}
