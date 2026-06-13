{den, ...}: {
  den.aspects.hardware.graphics.nvidia = {
    includes = [
      (den.batteries.unfree [
        "nvidia-x11"
        "nvidia-settings"
      ])
    ];

    nixos = {
      host,
      lib,
      config,
      ...
    }: let
      tryFindBusId = gpuType: (lib.findFirst (gpu: gpu.type == gpuType) null host.gpus).busId or "";
      nvidiaBusId = tryFindBusId "nvidia";
      amdgpuBusId = tryFindBusId "amd";
      intelBusId = tryFindBusId "intel";
    in {
      nixpkgs.config = {
        # Cups 2.4.19 is broken so ignore it
        problems.handlers.cups.broken = "ignore";
      };

      services.xserver.videoDrivers =
        [
          "nvidia"
        ]
        ++ lib.optional (amdgpuBusId != "") "amdgpu"
        ++ lib.optional (intelBusId != "") "modesetting";

      hardware.nvidia =
        {
          package = let
            inherit (config.boot.kernelPackages) nvidiaPackages;
          in
            if host.hasAspect den.aspects.optional.bleeding-edge.chaotic
            then nvidiaPackages.bleeding_edge
            else nvidiaPackages.stable;

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
