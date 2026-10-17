{
  den,
  lib,
  ...
}: let
  inherit
    (lib)
    mkOption
    types
    ;
in {
  den.aspects.core.nix.harmonia = {
    description = ''
      Serve this host's /nix/store as a signed Harmonia binary cache, reachable
      at `settings.endpoint` (default: the host's Tailscale Serve URL). Also
      registers that cache as a substituter for every machine evaluating this
      flake (client wiring lives in the `flake-file.nixConfig` above).

      Use over Tailscale Serve rather than a raw LAN port: Serve terminates TLS
      with an auto-issued *.ts.net certificate and is reachable from anywhere on
      the tailnet, so subscribers need no VPN-specific firewall rules. For a
      publicly reachable cache, replace Serve with Funnel and set `serve = false`.

      narinfo signatures guarantee integrity, so Transport security is provided
      end-to-end by Tailscale's WireGuard (or by Serve's TLS) and this cache is
      therefore trusted by `extra-trusted-public-keys`.
    '';

    includes = [
      den.aspects.security.tailscale
    ];

    hostSettings = {
      endpoint = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "https://kintoru.tail729600.ts.net";
        description = ''
          Public base URL at which the cache is reachable. Leave unset to
          derive it from the host's own Tailscale Serve URL.
        '';
      };

      message = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "Nix cache for kintoru, reachable over the tailnet.";
        description = ''
          Value served by the cache's `/nix-cache-info` endpoint for its
          `StoreDir` message field.
        '';
      };

      port = mkOption {
        type = types.port;
        default = 5000;
        description = "Port on which Harmonia listens locally.";
      };

      priority = mkOption {
        type = types.int;
        default = 5;
        description = ''
          Substituter priority. Lower wins: cache.nixos.org advertises 40 and
          amanako.cachix.org 10, so 5 makes this cache preferred while a miss
          still falls through to the others.
        '';
      };

      serve = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Expose the cache via Tailscale Serve (tailnet-only). Set to false when
          fronting it another way, e.g. `tailscale funnel` for a publicly
          reachable cache.
        '';
      };

      gc = {
        enable = mkOption {
          type = types.bool;
          default = true;
          description = ''
            Run harmonia-gc automatically to keep the cache from filling the
            store's filesystem. This only prunes store paths that no longer have
            a GC root (e.g. build dependencies pulled in for the cache), so it
            is independent of `nix.gc`.
          '';
        };

        ensureFree = mkOption {
          type = types.nullOr types.singleLineStr;
          default = null;
          example = "20G";
          description = ''
            Free space until this much is available, then stop. Accepts an
            absolute size like "20G" or a percentage like "20%". Unset means
            only the standard age/root rules apply.
          '';
        };

        deleteOlderThan = mkOption {
          type = types.nullOr types.singleLineStr;
          default = null;
          example = "30d";
          description = "Delete profile generations older than this.";
        };
      };
    };

    nixos = {
      config,
      host,
      ...
    }: let
      cfg = host.settings.core.nix.harmonia;
    in {
      sops.secrets.harmonia-key = {
        key = "key";
        sopsFile = host.settings.security.sops-host.secretsDir + "/harmonia.yaml";
      };

      services.harmonia.cache = {
        enable = true;
        signKeyPaths = [config.sops.secrets.harmonia-key.path];
        settings =
          {
            inherit (cfg) priority;
            bind = "[::]:${toString cfg.port}";
          }
          // lib.optionalAttrs (cfg.message != null) {inherit (cfg) message;};
      };

      services.harmonia.gc = {
        enable = cfg.gc.enable;
        automatic = cfg.gc.enable;
        inherit (cfg.gc) ensureFree deleteOlderThan;
      };

      # Harmonia listens on [::]:port (systemd socket activation). Only expose
      # it on the tailnet, not the LAN or the world.
      networking.firewall.interfaces.tailscale0.allowedTCPPorts = [cfg.port];

      systemd.services.tailscale-serve-harmonia = lib.mkIf cfg.serve {
        description = "Expose the Harmonia cache via Tailscale Serve";
        after = ["tailscaled.service"];
        requires = ["tailscaled.service"];
        wantedBy = ["multi-user.target"];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          Restart = "on-failure";
          RestartSec = "10s";
          TimeoutStartSec = "30s";
          # Raw TCP forwarder: this is *not* TLS-terminated by Serve (TLS is
          # only offered on 443/8443/10000, which are taken by Grafana and
          # Pi-hole). Harmonia is still only reachable over the tailnet, and
          # Tailscale's WireGuard encrypts it, so the substituter URL stays
          # plain http://.
          ExecStart = "${lib.getExe' config.services.tailscale.package "tailscale"} serve --yes --bg --tcp=8080 tcp://127.0.0.1:${toString cfg.port}";
        };
      };
    };
  };
}
