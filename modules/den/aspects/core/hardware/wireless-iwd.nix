{
  den,
  lib,
  ...
}: {
  den.aspects.core.hardware.wireless-iwd = {
    description = "Wireless networking using iwd (with dhcpcd).";

    nixos = {pkgs, ...}: {
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
          EnableNetworkConfiguration = true;
        };
        Network = {
          NameResolvingService = "resolvconf";
        };
      };
    };
  };
}
