{
  den.hosts.aarch64-linux.kintoru = {
    defaultChannel = "stable";

    settings = {
      basic.time.timeZone = "Europe/Belgrade";

      core = {
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
        "kusunoki:9100"
      ];

      security.pi-hole.listeningMode = "ALL";

      security.pi-hole-serve.domain = "kintoru.tail729600.ts.net";

      security.pi-hole-dhcp = {
        address = "192.168.100.81";
        router = "192.168.100.1";
        dhcpStart = "192.168.100.100";
        dhcpEnd = "192.168.100.200";
      };

      security.tailscale.advertiseRoutes = ["192.168.100.0/24"];

      security.ssh = {
        permitRootLogin = "prohibit-password";
        rootAuthorizedKeys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIPG5huz0B9qZ1gcuvMhCrc63piDJML/Hc/STMl55GWg awaremi"
        ];
      };

      security.sops-host.sshKeyPaths = [
        "/etc/ssh/ssh_host_ed25519_key"
      ];
    };
  };
}
