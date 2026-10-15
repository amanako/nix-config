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
  den.aspects.core.hardware.usb-gadget-ether-host = {
    description = ''
      Host (gateway) side of a USB gadget Ethernet tether
      (RNDIS/g_ether/CDC Ethernet). Shares this host's internet over the USB
      link using NetworkManager in "shared" mode (DHCP + NAT), renames the
      interface to a stable name via systemd.link, and opens the firewall for
      DHCP/DNS on that interface.

      Pair with a device-side aspect such as
      `core.hardware.usb-gadget-ether-device`, which advertises the matching
      `hostMac` and joins `subnet`.
    '';

    hostSettings = {
      interfaceName = mkOption {
        type = types.str;
        default = "usbg0";
        description = "Stable interface name to assign via systemd.link.";
      };

      hostMac = mkOption {
        type = types.str;
        default = "02:aa:aa:aa:aa:01";
        description = ''
          Locally administered MAC of the host-side interface. Must match
          `hostMac` on the paired device aspect, which sets it as `g_ether`'s
          `host_addr`.
        '';
      };

      subnet = mkOption {
        type = types.str;
        default = "10.0.0.0/24";
        example = "10.55.0.0/24";
        description = ''
          Private IPv4 subnet for the tether link. The host takes the `.1`
          address and hands the `.2` address to the device. Must match
          `subnet` on the paired device aspect.
        '';
      };
    };

    nixos = {
      host,
      lib,
      ...
    }: let
      cfg = host.settings.core.hardware.usb-gadget-ether-host;
      cidr = lib.splitString "/" cfg.subnet;
      netPrefix = lib.concatStringsSep "." (lib.take 3 (lib.splitString "." (lib.elemAt cidr 0)));
      hostAddress = "${netPrefix}.1/${lib.elemAt cidr 1}";
      deviceAddress = "${netPrefix}.2";
    in {
      systemd.network.links."10-${cfg.interfaceName}" = {
        enable = true;
        matchConfig.MACAddress = cfg.hostMac;
        linkConfig.Name = cfg.interfaceName;
      };

      networking.firewall.interfaces.${cfg.interfaceName} = {
        allowedUDPPorts = [53 67];
        allowedTCPPorts = [53];
      };

      networking.networkmanager.ensureProfiles.profiles."usb-gadget-ethernet" = {
        connection = {
          id = "USB Gadget Ethernet";
          type = "ethernet";
          uuid = "63cc5c90-ec89-4cd4-bf86-024d3679e6d5";
          autoconnect = true;
          interface-name = cfg.interfaceName;
        };
        ethernet.mac-address = cfg.hostMac;
        ipv4 = {
          address1 = hostAddress;
          method = "shared";
          "shared-dhcp-range" = "${deviceAddress},${deviceAddress}";
          "shared-dhcp-lease-time" = 3600;
        };
        ipv6.method = "disabled";
      };
    };
  };
}
