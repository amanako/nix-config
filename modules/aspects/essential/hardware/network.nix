{
  den.aspects.hardware.network = {
    provides.to-hosts.persys.directories = [
      # Remember connected networks
      "/etc/NetworkManager/system-connections"
    ];

    nixos.networking.networkmanager.enable = true;
  };
}
