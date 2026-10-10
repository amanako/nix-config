{
  den.hosts.x86_64-linux.ashikaga = {
    repoRoot = "/etc/nixos";
    defaultChannel = "unstable";

    settings = {
      extra.performance.cachyos-kernel = {
        variant = "bore";
        lto = true;
        uarch = "zen4";
      };

      core = {
        disks.disko-collector.devicePath = "/dev/disk/by-id/nvme-INTEL_SSDPEKNW512G8H_PHNH207409VP512A";

        display-managers.ly.batteryID = "BAT0";

        hardware.deviceType = "laptop";

        hardware.gpus = [
          {
            manufacturer = "nvidia";
            busId = "PCI:0@1:0:0";
          }
          {
            manufacturer = "amdgpu";
            busId = "PCI:0@5:0:0";
          }
        ];

        impermanence = {
          persistenceDir = "/persist";
          btrfs.disk-partition = "/dev/disk/by-id/nvme-INTEL_SSDPEKNW512G8H_PHNH207409VP512A-part2";
        };
      };

      basic.time.timeZone = "Europe/Belgrade";
    };
  };
}
