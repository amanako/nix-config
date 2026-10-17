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
  den.aspects.security.pi-hole-dhcp = {
    description = ''
      Run Pi-hole's DHCP server so LAN clients are handed Pi-hole as their DNS
      resolver. This host needs a static address and the upstream router's own
      DHCP server must be disabled.
    '';

    includes = [den.aspects.security.pi-hole];

    hostSettings = {
      address = mkOption {
        type = types.str;
        description = "Static IPv4 address of this Pi-hole host.";
      };
      router = mkOption {
        type = types.str;
        description = "Default gateway advertised to DHCP clients.";
      };
      dhcpStart = mkOption {
        type = types.str;
        description = "First IPv4 address of the DHCP pool.";
      };
      dhcpEnd = mkOption {
        type = types.str;
        description = "Last IPv4 address of the DHCP pool.";
      };
    };

    nixos = {host, ...}: let
      cfg = host.settings.security.pi-hole-dhcp;
    in {
      services.pihole-ftl = {
        openFirewallDHCP = true;
        settings = {
          dhcp = {
            active = true;
            start = cfg.dhcpStart;
            end = cfg.dhcpEnd;
            router = cfg.router;
          };

          dns.reply.host = {
            force4 = true;
            IPv4 = cfg.address;
          };
        };
      };
    };
  };
}
