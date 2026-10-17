{
  den,
  inputs,
  ...
}: {
  den.aspects.kintoru = {
    description = "Raspberry Pi 4 model B, 4GB RAM.";

    includes = [
      den.aspects.core.hardware.raspberry-pi.common
      den.aspects.core.hardware.usb-gadget-ether-device

      den.aspects.core.nix.common
      den.aspects.core.nix.lix
      den.aspects.core.nix.harmonia

      den.aspects.security.ssh
      den.aspects.security.tailscale
      den.aspects.security.tailscale.authkey-sops
      den.aspects.security.pi-hole-dhcp
      den.aspects.security.pi-hole-serve

      den.aspects.monitoring.grafana-serve
      den.aspects.monitoring.node-exporter
      den.aspects.monitoring.prometheus
    ];

    nixos = {host, ...}: let
      cfg = host.settings.security.pi-hole-dhcp;
    in {
      networking.dhcpcd.extraConfig = ''
        interface end0
        static ip_address=${cfg.address}/24
        static routers=${cfg.router}
        static domain_name_servers=127.0.0.1
      '';
    };
  };
}
