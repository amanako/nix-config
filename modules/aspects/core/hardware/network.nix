{
  den.aspects.core.hardware.network = {
    persys.directories = [
      # Remember connected networks
      "/etc/NetworkManager/system-connections"
    ];

    nixos.networking.networkmanager.enable = true;
  };
}
