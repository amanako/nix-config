{
  den,
  lib,
  ...
}: {
  den.aspects.core.hardware.nvidia = {
    includes = [
      (den.batteries.unfree [
        "nvidia-x11"
        "nvidia-settings"
      ])
    ];

    nixos = {
      host,
      config,
      ...
    }: let
      cfg = host.settings.core.hardware;
    in {
      nixpkgs.config = {
        # Cups 2.4.19 is broken so ignore it
        problems.handlers.cups.broken = "ignore";
      };

      services.xserver.videoDrivers = let
        hasGPUs =
          cfg.gpus
          |> builtins.any (_: true);
      in
        lib.mkIf hasGPUs
        (
          cfg.gpus
          |> map (el: el.manufacturer)
        );

      hardware.nvidia =
        {
          package = config.boot.kernelPackages.nvidiaPackages.stable;

          # Turing and newer architectures must use open kernel modules
          open = lib.mkDefault true;

          nvidiaSettings = true;
          # Necessary for wayland compositors and generally recommended to reduce tearing
          modesetting.enable = true;

          # Enable experimental sleep features - these are incompatible with sync
        }
        // lib.optionalAttrs (cfg.deviceType == "laptop") {
          # These are incompatible with sync
          powerManagement.enable = true;
          powerManagement.finegrained = true;

          # Handle hybrid laptops
          prime =
            cfg.gpus
            |> map (gpu: {
              name = "${gpu.manufacturer}BusId";
              value = gpu.busId;
            })
            |> builtins.listToAttrs
            |> lib.mergeAttrs
            {
              offload = {
                enable = true;
                # Enable use of nvidia-offload {command}
                enableOffloadCmd = true;
              };
              # TODO: Add cases for sync and reverseSync mode
              # sync.enable = true;
            };
        };
    };
  };
}
