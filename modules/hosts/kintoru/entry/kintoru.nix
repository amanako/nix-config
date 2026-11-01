{
  den.hosts.aarch64-linux.kintoru = {
    defaultChannel = "stable";

    settings = {
      basic.time.timeZone = "Europe/Belgrade";

      core = {
        disks = {
          disko-collector.devicePath = "/dev/disk/by-path/pci-0000:05:00.3-usb-0:1:1.0-scsi-0:0:0:0";
          rpi-boot.size = "1G";
          swap.size = "4G";
        };
        hardware.deviceType = "server";
        hardware.raspberry-pi = {
          board = "raspberry-pi-4";
          enableVc4 = true;
        };

        nix.harmonia.gc.ensureFree = "20G";
      };

      monitoring.grafana.domain = "kintoru.tail729600.ts.net";

      monitoring.prometheus.scrapeTargets = [
        "kintoru:9100"
      ];

      security = {
        pi-hole = {
          listeningMode = "ALL";
          blocklists = [
            "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/adblock/pro.plus.txt"
            "https://big.oisd.nl"
          ];
        };
        pi-hole-serve.domain = "kintoru.tail729600.ts.net";
        pi-hole-dhcp = {
          address = "192.168.100.81";
          router = "192.168.100.1";
          dhcpStart = "192.168.100.100";
          dhcpEnd = "192.168.100.200";
        };

        tailscale.advertiseRoutes = ["192.168.100.0/24"];

        ssh = {
          permitRootLogin = "prohibit-password";
          rootAuthorizedKeys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIPG5huz0B9qZ1gcuvMhCrc63piDJML/Hc/STMl55GWg awaremi"
          ];
        };

        sops-host.ageKeyFile = "/var/lib/sops-nix/key.txt";
      };
    };
  };
}
