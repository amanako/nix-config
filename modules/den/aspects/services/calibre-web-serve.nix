{
  den,
  lib,
  ...
}: {
  den.aspects.services.calibre-web-serve = {
    description = "Expose Calibre-Web over the tailnet via Tailscale Serve.";

    includes = [
      den.aspects.services.calibre-web
      den.aspects.security.tailscale
    ];

    nixos = {
      host,
      config,
      ...
    }: let
      cfg = host.settings.services.calibre-web;
    in {
      systemd.services.tailscale-serve-calibre-web = {
        description = "Expose Calibre-Web via Tailscale Serve";
        after = ["tailscaled.service"];
        requires = ["tailscaled.service"];
        wantedBy = ["multi-user.target"];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          Restart = "on-failure";
          RestartSec = "10s";
          TimeoutStartSec = "30s";
          ExecStart = "${lib.getExe' config.services.tailscale.package "tailscale"} serve --yes --bg --https=8444 http://127.0.0.1:${toString cfg.listenPort}";
        };
      };

      networking.firewall.interfaces.tailscale0.allowedTCPPorts = [8444];
    };
  };
}
