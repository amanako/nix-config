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
  den.aspects.security.tailscale = {
    description = "The easiest, most secure way to use WireGuard and 2FA.";

    hostSettings = {host, ...}: {
      exitNode = let
        isServer = host: (host |> lib.attrByPath ["settings" "core" "hardware" "deviceType"] "") == "server";
        serverHosts =
          den.hosts
          |> lib.concatMapAttrs (_: hosts: hosts)
          |> lib.filterAttrs (_: host: host |> isServer)
          |> lib.mapAttrsToList (name: value: value.hostName)
          |> lib.unique
          |> lib.remove host.hostName;
      in
        mkOption {
          type = types.nullOr (types.enum serverHosts);
          default = null;
          example =
            if serverHosts == []
            then null
            else lib.head serverHosts;
          description = ''
            Tailnet exit node to route this host's traffic through. Accepts either
            a hostname from this flake, or a Tailscale IP (100.64.0.0/10 for IPv4,
            fd7a:115c:a1e0::/48 for IPv6). Applied via `tailscale set --exit-node=...`
            after login, so hostnames resolve once the node is up.
          '';
        };

      advertiseRoutes = mkOption {
        type = types.listOf types.str;
        default = [];
        example = ["192.168.100.0/24"];
        description = ''
          LAN subnets this server advertises to the tailnet as subnet routes,
          so remote tailnet devices can reach services on those subnets without
          using an exit node. Routes must be approved in the Tailscale admin
          console after the node comes up.
        '';
      };
    };

    persistHost.directories = [
      "/var/lib/tailscale"
    ];

    nixos = {
      host,
      pkgs,
      ...
    }: let
      inherit (host.settings.core) hardware;
      inherit (host.settings.security) tailscale;

      isServer = hardware.deviceType == "server";

      # Tailscale performance best practice for exit nodes/subnet routers:
      # GRO forwarded UDP packets instead of segmenting them, cutting the
      # per-packet WireGuard cost (Linux 6.2+, Tailscale 1.54+).
      groForwarding = pkgs.writeShellScript "tailscale-gro-forwarding" ''
        NETDEV=$(${pkgs.iproute2}/bin/ip -o route get 8.8.8.8 | ${pkgs.coreutils}/bin/cut -f 5 -d " ")
        exec ${pkgs.ethtool}/bin/ethtool -K "$NETDEV" rx-udp-gro-forwarding on rx-gro-list off
      '';

      extraSetFlags =
        lib.optionals isServer (
          [
            "--ssh"
            "--advertise-exit-node"
          ]
          ++ lib.optionals (tailscale.advertiseRoutes != []) [
            "--advertise-routes=${lib.concatStringsSep "," tailscale.advertiseRoutes}"
          ]
        )
        ++ lib.optionals (tailscale.exitNode != null) [
          "--exit-node=${tailscale.exitNode}"
          "--exit-node-allow-lan-access"
        ];
    in {
      services.tailscale = {
        enable = true;
        openFirewall = true;
        # Maps each host's role to the nixpkgs routing-feature mode:
        # "server" enables IP forwarding (needed to advertise exit nodes /
        # subnet routes), while "client" loosens reverse path filtering so
        # return traffic arriving through the tunnel isn't dropped by the
        # firewall when this host uses someone else's exit node (see the
        # NixOS wiki). A server that itself uses an exit node needs both,
        # which nixpkgs models as "both". Hosts with neither get "none".
        useRoutingFeatures =
          if isServer && tailscale.exitNode != null
          then "both"
          else if isServer
          then "server"
          else if tailscale.exitNode != null
          then "client"
          else "none";
        inherit extraSetFlags;
      };

      systemd.services = lib.optionalAttrs isServer {
        tailscale-gro-forwarding = {
          description = "Enable UDP GRO forwarding on the default-route interface for Tailscale exit-node throughput.";
          wantedBy = ["multi-user.target"];
          wants = ["network-online.target"];
          after = ["network-online.target"];
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
            ExecStart = groForwarding;
          };
        };
      };
    };
  };
}
