{
  den.aspects.core.hardware.bluetooth = {
    persistHost.directories = [
      # Bluetooth device history
      "/var/lib/bluetooth"
    ];

    nixos.hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;

      settings.General = {
        DiscoverableTimeout = "120";
        PairableTimeout = "60";
        FastConnectable = true;
        Experimental = true;
        KernelExperimental = true;
      };
    };
  };
}
