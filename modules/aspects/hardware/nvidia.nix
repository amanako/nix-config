{ den, ... }:

{
  den.aspects.nvidia =
    { host, ... }:
    {
      provides.to-users = {
        includes = [
          (den._.unfree [
            "nvidia-x11"
            "nvidia-settings"
          ])
        ];
      };

      nixos =
        { lib, config, ... }:
        let
          tryFindBusId = gpuType: (lib.findFirst (gpu: gpu.type == gpuType) null host.gpus).busId or "";
          nvidiaBusId = tryFindBusId "nvidia";
          amdgpuBusId = tryFindBusId "amd";
          intelBusId = tryFindBusId "intel";
        in
        {
          services.xserver.videoDrivers = [
            "nvidia"
          ]
          ++ lib.optional (amdgpuBusId != "") "amdgpu"
          ++ lib.optional (intelBusId != "") "modesetting";

          hardware.nvidia = {
            package = config.boot.kernelPackages.nvidiaPackages.stable;

            # Turing and newer architectures must use open kernel modules
            open = lib.mkDefault true;

            nvidiaSettings = true;
            # Necessary for wayland compositors and generally recommended to reduce tearing
            modesetting.enable = true;

            # Enable experimental sleep features - these are incompatible with sync
          }
          // lib.optionalAttrs (host.deviceType == "laptop") {
            # These are incompatible with sync
            powerManagement.enable = true;
            powerManagement.finegrained = true;

            # Handle hybrid laptops
            prime = {
              inherit nvidiaBusId amdgpuBusId intelBusId;
              offload = {
                enable = true;
                # Enable use of nvidia via "nvidia-offload {command}"
                enableOffloadCmd = true;
              };
              # TODO: Add cases for sync and reverseSync mode
              # sync.enable = true;
            };
          };
        };
    };
}
