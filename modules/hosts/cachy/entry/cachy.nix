{
  den.hosts.x86_64-linux.cachy = {
    repoRoot = "/etc/nixos";

    settings = {
      extra.performance = {
        cachyos-kernel = {
          uarch = "zen4";
        };
      };

      core = {
        display-managers.ly.batteryID = "BAT0";

        hardware.deviceType = "laptop";

        impermanence = {
          persistenceDir = "/persist";
          btrfs.disk-partition = "/dev/disk/by-id/nvme-INTEL_SSDPEKNW512G8H_PHNH207409VP512A-part2";
        };
      };

      basic.time.timeZone = "Europe/Belgrade";
    };
  };
}
