{
  den,
  lib,
  ...
}: let
  inherit (lib) mkOption types;
in {
  den.aspects.security.pi-hole-serve = {
    description = "Expose the Pi-hole web interface over the tailnet via Tailscale Serve with an automatically issued certificate.";

    includes = [
      den.aspects.security.pi-hole
      den.aspects.security.tailscale
    ];

    hostSettings = {
      domain = mkOption {
        type = types.str;
        example = "host.tail000000.ts.net";
        description = ''
          Tailnet hostname of this Pi-hole instance, used as Pi-hole's
          `webserver.domain` so the dashboard redirects and API calls agree with
          the URL served by Tailscale.
        '';
      };
    };

    nixos = {
      host,
      config,
      ...
    }: let
      cfg = host.settings.security.pi-hole-serve;
      piholeCfg = host.settings.security.pi-hole;
    in {
      services.pihole-web.hostName = cfg.domain;

      systemd.services.tailscale-serve-pihole = {
        description = "Expose Pi-hole via Tailscale Serve";
        after = ["tailscaled.service"];
        requires = ["tailscaled.service"];
        wantedBy = ["multi-user.target"];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          Restart = "on-failure";
          RestartSec = "10s";
          TimeoutStartSec = "30s";
          ExecStart = "${lib.getExe' config.services.tailscale.package "tailscale"} serve --yes --bg --https=8443 http://127.0.0.1:${toString piholeCfg.webPort}";
        };
      };

      networking.firewall.interfaces.tailscale0.allowedTCPPorts = [8443];
    };
  };
}
