{ den, ... }:

{
  den.aspects.hardware = {
    nixos = {
      services.pipewire = {
        enable = true;
        alsa = {
          enable = true;
          support32Bit = true;
        };
        pulse.enable = true;
      };

      hardware.bluetooth.enable = true;
      hardware.bluetooth.powerOnBoot = true;

      networking.networkmanager.enable = true;

      boot.loader.efi.canTouchEfiVariables = true;
      boot.loader.limine = {
        enable = true;
        maxGenerations = 20;
        efiSupport = true;
        enableEditor = true;
      };
    };

    # TODO: Add conditional based on host configuration
    includes = [
      den.aspects.hardware._.nvidia
    ];
  };
}
