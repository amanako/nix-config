{
  den.aspects.core.hardware.network = {
    persistHost.directories = [
      # Remember connected networks
      "/etc/NetworkManager/system-connections"
    ];

    nixos.networking.networkmanager.enable = true;
  };
}
