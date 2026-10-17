{
  den,
  inputs,
  lib,
  ...
}: let
  inherit
    (lib)
    mkOption
    types
    ;
in {
  flake-file.inputs.node-exporter-full = {
    url = "github:rfmoz/grafana-dashboards";
    flake = false;
  };

  den.aspects.monitoring.grafana = {
    description = "Grafana dashboards for Prometheus metrics, provisioned with the Node Exporter Full dashboard.";

    includes = [
      den.aspects.monitoring.prometheus
    ];

    hostSettings = {
      domain = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "host.tail000000.ts.net";
        description = ''
          Public hostname of this Grafana instance when exposed via
          Tailscale Serve. Sets the root URL Grafana generates absolute
          links under. Leave null when only accessing it directly.
        '';
      };
    };

    nixos = {
      host,
      config,
      pkgs,
      ...
    }: let
      cfg = host.settings.monitoring.grafana;
      nodeExporterFull = "${inputs.node-exporter-full.outPath}/prometheus/node-exporter-full.json";
      dashboards = pkgs.linkFarm "grafana-dashboards" [
        {
          name = "node-exporter-full.json";
          path = nodeExporterFull;
        }
      ];
    in {
      # Grafana's service requires files be owned by grafana
      # default ownership with sops is null -> permission denied error while opening file.
      sops.secrets = {
        grafanaAdminPassword = {
          owner = "grafana";
          key = "password";
          sopsFile = host.settings.security.sops-host.secretsDir + "/grafana.yaml";
        };

        grafanaSecretKey = {
          owner = "grafana";
          key = "key";
          sopsFile = host.settings.security.sops-host.secretsDir + "/grafana.yaml";
        };
      };

      services.grafana = {
        enable = true;

        settings = {
          security.admin_password = "$__file{${config.sops.secrets.grafanaAdminPassword.path}}";
          security.secret_key = "$__file{${config.sops.secrets.grafanaSecretKey.path}}";
          server.root_url = lib.mkIf (cfg.domain != null) "https://${cfg.domain}/";
        };

        provision = {
          enable = true;
          datasources.settings.datasources = [
            {
              name = "Prometheus";
              type = "prometheus";
              uid = "prometheus";
              url = "http://127.0.0.1:9090";
            }
          ];
          dashboards.settings.providers = [
            {
              name = "local";
              options.path = dashboards;
            }
          ];
        };
      };
    };
  };
}
