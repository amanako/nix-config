{lib, ...}: let
  inherit
    (lib)
    mkOption
    types
    ;
in {
  den.aspects.sys.prometheus = {
    description = "Scrape and retain node_exporter metrics from included hosts.";

    hostSettings = {
      scrapeTargets = mkOption {
        type = types.listOf types.str;
        example = [
          "hostname1:9100"
          "hostname2:9100"
        ];
        description = ''
          Host and port pairs (`host:port`) of node_exporter instances to scrape.
          Names must resolve on this host (e.g. via Tailscale MagicDNS).
        '';
      };

      retention = mkOption {
        type = types.str;
        default = "14d";
        example = "30d";
        description = "How long to retain scraped metrics on disk.";
      };
    };

    # Prometheus keeps its TSDB under the service's working directory
    # (`/var/lib/${stateDir}`). Derive it from the effective systemd value.
    persistHost = {config, ...}: let
      stateDir = config.systemd.services.prometheus.serviceConfig.WorkingDirectory;
    in {
      directories = [
        {
          directory = stateDir;
          user = "prometheus";
          group = "prometheus";
          mode = "0700";
        }
      ];
    };

    nixos = {host, ...}: let
      cfg = host.settings.sys.prometheus;
    in {
      services.prometheus = {
        enable = true;
        port = 9090;
        retentionTime = cfg.retention;
        globalConfig.scrape_interval = "15s";
        scrapeConfigs = [
          {
            job_name = "node";
            static_configs = [{targets = cfg.scrapeTargets;}];
          }
        ];
      };

      networking.firewall.allowedTCPPorts = [9090];
    };
  };
}
