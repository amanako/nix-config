{
  den.aspects.hardware._.nvidia = {
    nixos =
      { lib, config, ... }:
      {
        hardware.graphics = {
          enable = true;
          enable32Bit = true;
        };

        services.xserver.videoDrivers = [ "nvidia" ];

        hardware.nvidia = {
          # Turing and newer architectures must use open kernel modules
          open = lib.mkDefault true;
          package = lib.mkDefault config.boot.kernelPackages.nvidiaPackages.stable;
          modesetting.enable = true;

          # Enable experimental sleep features
          powerManagement.enable = true;
          powerManagement.finegrained = true;

          # Enable nvidia settings for manual tweaks
          nvidiaSettings = true;

          prime = {
            # Enable use of nvidia via "nvidia-offload {command}"
            offload = {
              enable = true;
              enableOffloadCmd = true;
            };

            # Hardware specific - https://nixos.wiki/wiki/Nvidia#Configuring_Optimus_PRIME:_Bus_ID_Values_.28Mandatory.29
            amdgpuBusId = "PCI:0@5:0:0";
            nvidiaBusId = "PCI:0@1:0:0";
          };
        };
      };
  };
}
