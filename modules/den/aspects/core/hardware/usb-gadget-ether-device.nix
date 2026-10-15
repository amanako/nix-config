{
  den,
  inputs,
  lib,
  ...
}: let
  inherit
    (lib)
    mkOption
    types
    ;
in {
  den.aspects.core.hardware.usb-gadget-ether-device = {
    description = ''
      Device (client) side of a USB gadget Ethernet tether. Loads the
      Raspberry Pi USB gadget (`g_ether`, via `nixos-raspberrypi`'s
      `usb-gadget-ethernet` module) with pinned MACs and a static address so
      the paired `core.hardware.usb-gadget-ether-host` can reliably recognise
      and route to it.

      Include this aspect to opt in; remove it to opt out.
    '';

    hostSettings = {
      hostMac = mkOption {
        type = types.str;
        default = "02:aa:aa:aa:aa:01";
        description = ''
          MAC the device advertises to the host (`g_ether`'s `host_addr`).
          Must match `hostMac` on the paired
          `core.hardware.usb-gadget-ether-host` aspect.
        '';
      };

      deviceMac = mkOption {
        type = types.str;
        default = "02:aa:aa:aa:aa:02";
        description = ''
          Locally administered MAC of the device's own USB interface
          (`g_ether`'s `dev_addr`).
        '';
      };

      subnet = mkOption {
        type = types.str;
        default = "10.0.0.0/24";
        example = "10.55.0.0/24";
        description = ''
          Private IPv4 subnet for the tether link. The device takes the `.2`
          address. Must match `subnet` on the paired
          `core.hardware.usb-gadget-ether-host` aspect.
        '';
      };
    };

    nixos = {
      host,
      lib,
      ...
    }: let
      cfg = host.settings.core.hardware.usb-gadget-ether-device;
      cidr = lib.splitString "/" cfg.subnet;
      netPrefix = lib.concatStringsSep "." (lib.take 3 (lib.splitString "." (lib.elemAt cidr 0)));
      deviceAddress = "${netPrefix}.2";
    in {
      imports = [
        inputs.nixos-raspberrypi.nixosModules.usb-gadget-ethernet
      ];

      # Pin the gadget MACs: `g_ether` randomises `host_addr`/`dev_addr` on
      # every boot otherwise, which breaks the host-side systemd `.link`
      # rename (matched on `hostMac`) and therefore the shared/NAT profile.
      boot.extraModprobeConfig = ''
        options g_ether host_addr=${cfg.hostMac} dev_addr=${cfg.deviceMac}
      '';

      networking.interfaces.usb0.ipv4.addresses = [
        {
          address = deviceAddress;
          prefixLength = lib.toInt (lib.elemAt cidr 1);
        }
      ];
    };
  };
}
