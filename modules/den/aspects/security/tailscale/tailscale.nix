{
  den,
  lib,
  ...
}: {
  den.aspects.security.tailscale = let
    inherit
      (lib)
      mkOption
      types
      ;
  in {
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
    };

    nixos = {host, ...}: let
      inherit (host.settings.core) hardware;
      inherit (host.settings.security) tailscale;

      isServer = hardware.deviceType == "server";

      extraSetFlags =
        lib.optionals isServer [
          "--ssh"
          "--advertise-exit-node"
        ]
        ++ lib.optionals (tailscale.exitNode != null) [
          "--exit-node=${tailscale.exitNode}"
        ];
    in {
      services.tailscale =
        {
          enable = true;
          inherit extraSetFlags;
        }
        // lib.optionalAttrs isServer {
          useRoutingFeatures = "server";
        };
    };
  };
}
