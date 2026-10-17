{
  den,
  lib,
  ...
}: {
  den.aspects.services.syncthing-serve = {
    description = "Expose the Syncthing web UI over the tailnet via Tailscale Serve.";

    includes = [
      den.aspects.services.syncthing
      den.aspects.security.tailscale
    ];

    hostSettings = {
      listenPort = lib.mkOption {
        type = lib.types.port;
        default = 8384;
        description = "Local port for syncthing serving. Expose it with `services.calibre-web-serve` rather than opening it directly.";
      };

      outwardPort = lib.mkOption {
        type = lib.types.port;
        default = 8445;
        description = "Tailscale port to serve syncthing on.";
      };
    };

    nixos = {
      host,
      config,
      ...
    }: let
      cfg = host.settings.services.syncthing-serve.listenPort;
    in {
      systemd.services.tailscale-serve-syncthing = {
        description = "Expose Syncthing via Tailscale Serve";
        after = ["tailscaled.service"];
        requires = ["tailscaled.service"];
        wantedBy = ["multi-user.target"];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          Restart = "on-failure";
          RestartSec = "10s";
          TimeoutStartSec = "30s";
          ExecStart = "${lib.getExe' config.services.tailscale.package "tailscale"} serve --yes --bg --https=${cfg.outwardPort} http://127.0.0.1:${cfg.listenPort}";
        };
      };

      networking.firewall.interfaces.tailscale0.allowedTCPPorts = [cfg.outwardPort];
    };
  };
}
