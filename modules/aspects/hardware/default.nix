{
  den,
  lib,
  ...
}: {
  den.aspects.hardware = {host}: {
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
        settings = {
          General = {
            Experimental = true;
            Testing = true;
            KernelExperimental = true;
          };
        };
      };

      networking.networkmanager.enable = true;
    };
  };
}
