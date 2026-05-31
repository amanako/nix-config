{
  den.aspects.hardware.bluetooth = {
    provides.to-hosts.persys.directories = [
      # Bluetooth device history
      "/var/lib/bluetooth"
    ];

    nixos.hardware.bluetooth = {
      enable = true;
      # package = pkgs-stable.bluez;
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
