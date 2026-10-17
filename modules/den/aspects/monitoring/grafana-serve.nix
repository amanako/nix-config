{
  den,
  lib,
  ...
}: {
  den.aspects.monitoring.grafana-serve = {
    description = "Expose Grafana over the tailnet at https://<domain> via Tailscale Serve with an automatically issued certificate.";

    includes = [
      den.aspects.monitoring.grafana
      den.aspects.security.tailscale
    ];

    hostConflicts.assertions = [
      ({host, ...}: let
        cfg = host.settings.monitoring.grafana;
      in [
        {
          subject = [
            "monitoring"
            "grafana-serve"
          ];
          target = [
            "monitoring.grafana"
          ];
          assertion = cfg.domain != null;
          message = ''
            monitoring.grafana-serve: set `${host.hostName}.settings.monitoring.grafana.domain`
            so Tailscale Serve and Grafana agree on the public hostname.
          '';
        }
      ])
    ];

    nixos = {config, ...}: {
      systemd.services.tailscale-serve-grafana = {
        description = "Expose Grafana via Tailscale Serve";
        after = ["tailscaled.service"];
        requires = ["tailscaled.service"];
        wantedBy = ["multi-user.target"];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          Restart = "on-failure";
          RestartSec = "10s";
          TimeoutStartSec = "30s";
          ExecStart = "${lib.getExe' config.services.tailscale.package "tailscale"} serve --yes --bg --https=443 http://127.0.0.1:3000";
        };
      };

      networking.firewall.interfaces.tailscale0.allowedTCPPorts = [443];
    };
  };
}
