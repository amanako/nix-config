{
  den,
  lib,
  ...
}: {
  den.aspects.sys.grafana-serve = {
    description = "Expose Grafana over the tailnet at https://<domain> via Tailscale Serve with an automatically issued certificate.";

    includes = [
      den.aspects.sys.grafana
      den.aspects.security.tailscale
    ];

    hostConflicts.assertions = [
      ({host, ...}: let
        cfg = host.settings.sys.grafana;
      in [
        {
          subject = [
            "sys"
            "grafana-serve"
          ];
          target = [
            "sys.grafana"
          ];
          assertion = cfg.domain != null;
          message = ''
            sys.grafana-serve: set `${host.name}.settings.sys.grafana.domain`
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
