{
  den.aspects.hardware.network = {host}: {
    persys.directories = [
      # Remember connected networks
      "/etc/NetworkManager/system-connections"
    ];

    nixos.networking.networkmanager.enable = true;
  };
}
