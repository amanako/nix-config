{
  den,
  lib,
  ...
}: {
  den.aspects.services.forgejo-serve = {
    description = "Expose forgejo over the tailnet via Tailscale serve.";

    includes = [
      den.aspects.services.forgejo
      den.aspects.security.tailscale
    ];

    hostSettings = {
      domain = lib.mkOption {
        type = lib.types.str;
        example = "host.tail000000.ts.net";
        description = "Tailscale domain name";
      };

      listenPort = lib.mkOption {
        type = lib.types.port;
        example = 8002;
        default = 8003;
        description = ''
          Port on localhost for forgejo to listen to.
        '';
      };

      port = lib.mkOption {
        type = lib.types.port;
        example = 1020;
        default = 1021;
        description = ''
          Port on tailnet to use for serving the instance.
        '';
      };
    };

    nixos = {
      host,
      lib,
      config,
      ...
    }: let
      cfg = host.settings.services.forgejo-serve;
      portSuffix = lib.optionalString (cfg.port != 443) ":${toString cfg.port}";
    in {
      services.forgejo.settings.server = {
        DOMAIN = cfg.domain;
        ROOT_URL = "https://${cfg.domain}${portSuffix}/";
        HTTP_ADDR = "127.0.0.1";
        HTTP_PORT = cfg.listenPort;
      };

      systemd.services.tailscale-serve-forgejo = {
        description = "Expose forgejo via Tailscale Serve";
        after = ["tailscaled.service"];
        requires = ["tailscaled.service"];
        wantedBy = ["multi-user.target"];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          Restart = "on-failure";
          RestartSec = "10s";
          TimeoutStartSec = "60s";
          ExecStart = "${lib.getExe' config.services.tailscale.package "tailscale"} serve --yes --bg --https=${toString cfg.port} http://127.0.0.1:${toString cfg.listenPort}";
        };
      };
    };
  };
}
