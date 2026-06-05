{
  den.aspects.hardware.bluetooth = {host}: {
    persys.directories = [
      # Bluetooth device history
      "/var/lib/bluetooth"
    ];

    nixos.hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;

      settings.General = {
        DiscoverableTimeout = "120";
        PariableTimeout = "60";
        FastConnectable = true;
        Experimental = true;
      };
    };
  };
}
