{
  den,
  lib,
  ...
}: {
  den.aspects.hardware = {host, ...}: {
    includes =
      lib.optional
      host.wantsNvidiaSupport
      den.aspects.nvidia;

    nixos = {
      services.pipewire = {
        enable = true;
        alsa = {
          enable = true;
          support32Bit = true;
        };
        pulse.enable = true;
      };

      hardware.bluetooth = {
        enable = true;
        powerOnBoot = true;
      };

      networking.networkmanager.enable = true;
    };
  };
}
