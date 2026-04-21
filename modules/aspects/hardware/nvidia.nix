{
  den.aspects.nvidia = {
    nixos =
      { lib, config, ... }:
      {
        services.xserver.videoDrivers = [ "nvidia" ];

        hardware.nvidia = {
          package = config.boot.kernelPackages.nvidiaPackages.beta;

          # Turing and newer architectures must use open kernel modules
          open = lib.mkDefault true;

          nvidiaSettings = true;
          # Reduce tearing - highly recommended for sync mode
          modesetting.enable = true;

          # Enable experimental sleep features - these are incompatible with sync
          powerManagement.enable = true;
          powerManagement.finegrained = true;

          prime = {
            # Enable use of nvidia via "nvidia-offload {command}"
            offload = {
              enable = true;
              enableOffloadCmd = true;
            };
            # sync.enable = true;

            # Hardware specific - https://nixos.wiki/wiki/Nvidia#Configuring_Optimus_PRIME:_Bus_ID_Values_.28Mandatory.29
            amdgpuBusId = "PCI:0@5:0:0";
            nvidiaBusId = "PCI:0@1:0:0";
          };
        };
      };
  };
}
