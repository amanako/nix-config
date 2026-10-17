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
  den.aspects.core.hardware.wireless-iwd = {
    description = "Wireless networking using iwd (with dhcpcd).";

    hostSettings = {
      networkConfiguration = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether iwd configures the interface address and DNS itself (`EnableNetworkConfiguration`).
          Disable it when another client, such as dhcpcd with a static profile, manages addressing.
        '';
      };
    };

    nixos = {
      host,
      pkgs,
      ...
    }: let
      cfg = host.settings.core.hardware.wireless-iwd;
    in {
      networking = {
        wireless.iwd.enable = true;
        dhcpcd.allowInterfaces = ["en*" "eth*" "usb*" "wlan*"];
      };

      networking.networkmanager.wifi.backend = "iwd";

      environment.systemPackages = with lib; [
        (getBin pkgs.wifitui)
      ];

      networking.wireless.iwd.settings = {
        General = {
          EnableNetworkConfiguration = cfg.networkConfiguration;
        };
        Network = {
          NameResolvingService = "resolvconf";
        };
      };
    };
  };
}
