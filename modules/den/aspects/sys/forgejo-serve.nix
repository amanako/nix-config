{
  den,
  lib,
  ...
}: {
  den.aspects.sys.forgejo-serve = {
    description = "Expose forgejo over the tailnet via Tailscale serve.";

    includes = [
      den.aspects.core.hardware
      den.aspects.sys.forgejo
      den.aspects.security.tailscale
    ];

    hostSettings = {host, ...}:
      {
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
      }
      // lib.optionalAttrs (host.settings.core.hardware.deviceType == "server") {
        sshPort = lib.mkOption {
          type =
            (lib.types.addCheck lib.types.port (p: p != 22))
            // {
              description = "TCP port other than 22";
            };
          example = 2022;
          default = 2222;
          description = ''
            Port to start the builtin server on since tailscale is set to use ssh when device is of type server.
            Since port 22 is taken by tailscale in this state and can't be used by sshd, anything other than that not taken will suffice.
          '';
        };
      };

    nixos = {
      host,
      lib,
      config,
      ...
    }: let
      cfg = host.settings.sys.forgejo-serve;
      portSuffix = lib.optionalString (cfg.port != 443) ":${toString cfg.port}";
      isServer = host.settings.core.hardware.deviceType == "server";
    in {
      services.forgejo.settings = {
        session = {
          # Avoid collision with other services running on tailscale when serving over tailsclae.
          # Not necessary when only running forgejo but harmless.
          COOKIE_NAME = "forgejo_session";

          COOKIE_SECURE = true;
        };

        server =
          {
            DOMAIN = cfg.domain;
            ROOT_URL = "https://${cfg.domain}${portSuffix}/";
            HTTP_ADDR = "127.0.0.1";
            HTTP_PORT = cfg.listenPort;
          }
          // lib.optionalAttrs isServer {
            START_SSH_SERVER = true;
            SSH_PORT = 2222;
          };
      };

      networking.firewall.interfaces.tailscale0.allowedTCPPorts = lib.optional isServer 2222;

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
