{
  den.hosts.x86_64-linux.ashikaga = {
    repoRoot = "/home/isamu/nix-config";
    defaultChannel = "unstable";

    settings = {
      basic.time.timeZone = "Europe/Belgrade";

      extra.performance.cachyos-kernel = {
        variant = "bore";
        lto = true;
        uarch = "zen4";
      };

      core = {
        disks.disko-collector.devicePath = "/dev/disk/by-id/nvme-INTEL_SSDPEKNW512G8H_PHNH207409VP512A";

        display-managers.ly.batteryID = "BAT0";

	boot.limine.wallpapers = [
	  {
	    url = "https://images4.alphacoders.com/792/thumb-1920-792019.png";
            hash = "sha256-UkeEBzNOGx4pRPtxgxcyl9jiEqV7aHWZs1Q8uuBL/KE=";
	  }
        ]; 	  

        hardware = {
	  deviceType = "laptop";

	  gpus = [
          {
            manufacturer = "nvidia";
            busId = "PCI:0@1:0:0";
          }
          {
            manufacturer = "amdgpu";
            busId = "PCI:0@5:0:0";
          }
        ];

	  nvidia.primeMode = "offload";
	};

        impermanence = {
          persistenceDir = "/persist";
          btrfs.disk-partition = "/dev/disk/by-id/nvme-INTEL_SSDPEKNW512G8H_PHNH207409VP512A-part2";
        };
      };

      security.sops-host.ageKeyFile = "/etc/key.txt";
    };
  };
}
