{
  den.aspects.hardware.network = {host, ...}: {
    provides.to-hosts.persys.directories = [
      # Remember connected networks
      "/etc/NetworkManager/system-connections"
    ];

    nixos.networking.networkmanager.enable = true;
  };
}
