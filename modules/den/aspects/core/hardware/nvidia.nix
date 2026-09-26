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

    hostConflicts.assertions = [
      ({host, ...}: let
        cfg = host.settings.core.hardware;
        manufacturers =
          cfg.gpus
          |> map (gpu: gpu.manufacturer);
      in [
        {
          subject = [
            "core.hardware.gpus"
          ];
          target = [
            "core.hardware.nvidia.prime"
          ];
          assertion = manufacturers == (manufacturers |> lib.unique);
          message = ''
            core.hardware.gpus: each manufacturer may appear at most once.
            `hardware.nvidia.prime` has a single `<manufacturer>BusId` per
            manufacturer, so a duplicate would silently drop a bus ID.
          '';
        }
      ])
    ];

    hostSettings = {host, ...}: let
      inherit
        (lib)
        mkOption
        types
        ;
      isHybrid = builtins.length host.settings.core.hardware.gpus >= 2;
    in {
      primeMode = mkOption {
        type = types.nullOr (
          types.enum [
            "offload"
            "sync"
            "reverseSync"
          ]
        );
        default = null;
        example = "offload";
        description = ''
          PRIME mode for hybrid graphics (integrated GPU + discrete NVIDIA GPU).
          Requires at least two GPUs declared in `core.hardware.gpus`; on
          single-GPU hosts this option is read-only (left at `null`). The modes
          are mutually exclusive:

          - `offload` renders on the integrated GPU and keeps the discrete GPU
            asleep until explicitly requested via the generated `nvidia-offload`
            wrapper. Works under Wayland.
          - `sync` renders on the discrete GPU and mirrors frames to the
            integrated GPU. X11 only; incompatible with power management.
          - `reverseSync` is `sync` but with the discrete GPU as primary output,
            so external displays wired to it work. X11 only; experimental and
            incompatible with power management.

          Keep the default to leave `hardware.nvidia.prime` untouched.
        '';
        readOnly = !isHybrid;
      };
    };

    nixos = {
      host,
      config,
      ...
    }: let
      cfg = host.settings.core.hardware;
      isLaptop = cfg.deviceType == "laptop";
      inherit (cfg.nvidia) primeMode;

      busIds =
        cfg.gpus
        |> map (gpu: {
          name = "${gpu.manufacturer}BusId";
          value = gpu.busId;
        })
        |> builtins.listToAttrs;

      primeModes = {
        offload = {
          offload = {
            enable = true;
            enableOffloadCmd = true;
          };
        };
        sync = {
          sync.enable = true;
        };
        reverseSync = {
          reverseSync.enable = true;
        };
      };

      # Power management puts the discrete GPU to sleep, which is incompatible
      # with sync and reverseSync.
      powerManagement = {
        powerManagement.enable = true;
        powerManagement.finegrained = true;
      };
    in {
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
        }
        // lib.optionalAttrs (primeMode != null) {
          # `sync`/`reverseSync` rely on xrandr mirroring
          # via `services.xserver.displayManager.setupCommands`, which Wayland
          # compositors (e.g. niri) don't apply. Not asserted — session choice
          # is a runtime decision and checking would be complicated.
          prime = busIds // primeModes.${primeMode};
        }
        // lib.optionalAttrs (isLaptop && primeMode == "offload")
        powerManagement;
    };
  };
}
