{
  den.hosts.x86_64-linux.nebula = {
    settings = {
      basic.time.timeZone = "Europe/Belgrade";

      extra.performance = {
        cachyos-kernel = {
          variant = "bore";
          lto = true;
          uarch = "zen4";
        };
      };

      core = {
        impermanence = {
          btrfs.disk-partition = "/dev/disk/by-id/nvme-SAMSUNG_MZVLQ512HBLU-00B00_S6F5NS0T325504-part2";
          persistenceDir = "/persist";
          dontEnableUsers = false;
        };

        display-managers.ly.batteryID = "BAT1";

        boot.limine.wallpapers = [
          {
            url = "https://cdn.cloudflare.steamstatic.com/steam/apps/2712550/library_hero.jpg";
            hash = "sha256-gcVUDQ9YXgA9fB5Mn8yqPfEwP2OSX9ssrNwLYcwN+cI=";
          }
          {
            url = "https://w.wallhaven.cc/full/yq/wallhaven-yqg6r7.jpg";
            hash = "sha256-RI/KERuKYPLcIpjawRsElocoOtEcZy6UR/D4dqoLqSg=";
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

      security.sops.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
    };
  };
}
