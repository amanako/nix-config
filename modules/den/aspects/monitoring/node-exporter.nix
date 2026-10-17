{
  den.aspects.monitoring.node-exporter = {
    description = "Expose system metrics (CPU, memory, disk, network, temperature) via Prometheus node_exporter.";

    nixos.services.prometheus.exporters.node = {
      enable = true;
      enabledCollectors = [
        "hwmon"
        "systemd"
      ];
      port = 9100;
      openFirewall = true;
    };
  };
}
