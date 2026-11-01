{lib, ...}: let
  inherit
    (lib)
    mkOption
    types
    ;
in {
  den.aspects.security.pi-hole = {
    hostSettings = {
      listeningMode = mkOption {
        type = types.enum ["LOCAL" "ALL"];
        default = "LOCAL";
        example = "ALL";
        description = ''
          Pi-hole interface listening mode. `LOCAL` only accepts queries from
          addresses on a local subnet. Set to `ALL` when clients query from
          routed or VPN sources not on a local subnet (e.g. Tailscale), where
          `LOCAL` silently drops their queries. `ALL` permits queries from any
          source that can reach port 53, so only use it on trusted networks.
        '';
      };

      webPort = mkOption {
        type = types.port;
        default = 80;
        example = 8080;
        description = ''
          Local HTTP port for the Pi-hole web interface. Tailscale Serve
          terminates TLS and proxies to this port, so it must differ from the
          Tailscale Serve HTTPS port.
        '';
      };

      blocklists = mkOption {
        type = types.listOf types.str;
        default = [];
        example = [
          "0.0.0.0 ads.example.com"
          "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/wildcard/pro-onlydomains.txt"
        ];
        description = ''
          URLs of blocklists to use. Pi-hole accepts fetched lists with one domain
          per line or hosts-file format.
        '';
      };
    };

    nixos = {host, ...}: let
      cfg = host.settings.security.pi-hole;
    in {
      systemd.services.pihole-ftl-setup = {
        after = [
          "time-sync.target"
        ];
        wants = [
          "time-sync.target"
        ];
      };

      services = {
        pihole-ftl = {
          enable = true;
          openFirewallDNS = true;
          openFirewallWebserver = true;
          settings = {
            dns = {
              upstreams = [
                "9.9.9.9"
                "149.112.112.112"
                "2620:fe::fe"
                "2620:fe::9"
              ];
              inherit (cfg) listeningMode;
            };

            dhcp.ipv6 = true;

            webserver = {
              port = toString cfg.webPort;

              api.prettyJSON = true;
            };

            misc.extraLogging = true;
            dns.dnssec = false;
          };

          lists =
            cfg.blocklists
            |> lib.map (
              url: {
                enabled = true;
                type = "block";
                inherit url;
              }
            );
        };

        pihole-web = {
          enable = true;
          ports = [(toString cfg.webPort)];
        };
      };
    };
  };
}
