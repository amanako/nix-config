{
  den.hosts.x86_64-linux.nebula = {
    settings = {
      basic.time.timeZone = "Europe/Belgrade";

      core = {
        impermanence = {
          btrfs.disk-partition = "/dev/disk/by-id/nvme-SAMSUNG_MZVLQ512HBLU-00B00_S6F5NS0T325504-part2";
          persistenceDir = "/persist";
          dontEnableUsers = false;
        };

        nix-cachyos-kernel = {
          variant = "bore";
          lto = true;
          uarch = "zen4";
        };

        displayManagers.ly.batteryID = "BAT1";

        boot.limine.wallpapers = [
          {
            url = "https://cdn.cloudflare.steamstatic.com/steam/apps/2712550/library_hero.jpg";
            # Hash can be obtained by trying to rebuild system without specifying hash, which will
            # prompt user with hash mismatch error. The message then contains correct hash in "got" row
            # that is the one beginning with sha256 and not full of uppercase As
            hash = "sha256-gcVUDQ9YXgA9fB5Mn8yqPfEwP2OSX9ssrNwLYcwN+cI=";
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
        };
      };
    };
  };
}
