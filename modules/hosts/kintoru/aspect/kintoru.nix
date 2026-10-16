{
  den,
  inputs,
  ...
}: {
  den.aspects.kintoru = {
    description = "Raspberry Pi 4 model B, 4GB RAM.";

    includes = [
      den.aspects.core.hardware.raspberry-pi.common
      den.aspects.core.hardware.wireless-iwd
      den.aspects.core.hardware.usb-gadget-ether-device

      den.aspects.core.nix.common
      den.aspects.core.nix.lix

      den.aspects.security.ssh
      den.aspects.security.pi-hole-dhcp
    ];

    nixos = {host, ...}: let
      cfg = host.settings.security.pi-hole-dhcp;
    in {
      networking.dhcpcd.extraConfig = ''
        interface wlan0
        static ip_address=${cfg.address}/24
        static routers=${cfg.router}
        static domain_name_servers=127.0.0.1
      '';
    };

    persistHost.directories = [
      "/etc/ssh"
    ];
  };
}
