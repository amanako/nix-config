{
  den.aspects.core.hardware.network = {
    persistSystem.directories = [
      # Remember connected networks
      "/etc/NetworkManager/system-connections"
    ];

    nixos.networking.networkmanager.enable = true;
  };
}
