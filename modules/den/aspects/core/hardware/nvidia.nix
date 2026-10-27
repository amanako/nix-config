{
  den,
  inputs,
  lib,
  ...
}: let
  inherit
    (lib)
    mkOption
    types
    ;
in {
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
      ({host, ...}: let
        cfg = host.settings.core.hardware;
        emptyBusId = cfg.gpus |> lib.filter (g: g.busId == "");
      in [
        {
          subject = [
            "core.hardware.nvidia"
          ];
          target = [
            "core.hardware.nvidia.prime"
          ];
          assertion = cfg.nvidia.primeMode == null || emptyBusId == [];
          message = ''
            primeMode is set to ${toString cfg.nvidia.primeMode}, however
            `busId` has a value of "" for these GPUs: ${emptyBusId |> lib.concatMapStringsSep "," (g: g.manufacturer)}.
            For configuration reference ${host.name}.settings.core.hardware.gpus option.
          '';
        }
      ])
    ];

    hostSettings = {host, ...}: {
      package = let
        inherit (inputs.self.nixosConfigurations.${host.hostName}.config.boot.kernelPackages) nvidiaPackages;
        channels = [
          {
            name = "stable";
            desc = "the safe default. A well-tested driver that works for most people.";
          }
          {
            name = "production";
            desc = "nvidia's long-term, thoroughly vetted driver. Choose this if reliability matters more than new features.";
          }
          {
            name = "latest";
            desc = "the newest regular release. Gets fixes and support for new GPUs sooner, with slightly less testing.";
          }
          {
            name = "beta";
            desc = "an early preview of the next release. May have bugs or crashes, so only use it if you need a fix that hasn't landed elsewhere.";
          }
          {
            name = "new_feature";
            desc = "Nvidia's branch for newly added features. Newer than `production`, but not as long-tested.";
          }
          {
            name = "vulkan_beta";
            desc = "a preview driver for the latest Vulkan graphics features. Mainly for developers and testers.";
          }
        ];
        available =
          channels
          |> lib.filter (p: nvidiaPackages ? ${p.name});
        names =
          available
          |> lib.map (p: p.name);
      in
        mkOption rec {
          type = types.enum names;
          default = "stable";
          example = names |> lib.findFirst (n: n != default) default;
          description = ''
            Which NVIDIA driver version to use. If you're unsure, leave setting on default value.

            ${available |> lib.concatMapStringsSep "\n" (p: "- `${p.name}`: ${p.desc}")}
          '';
        };

      open = mkOption {
        type = types.bool;
        default = true;
        example = false;
        description = ''
          Use NVIDIA's open kernel modules. Required for Turing and newer
          (GTX 16xx / RTX 20xx and up); must be `false` for Maxwell, Pascal
          and Volta (GTX 9xx / 10xx, Titan V). Also gates fine-grained power
          management, which has the same hardware requirement.
        '';
      };

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
        readOnly = let
          cfg = host.settings.core.hardware;
          isHybrid = builtins.length cfg.gpus >= 2;
          hasNvidia =
            cfg.gpus
            |> lib.any (el: el.manufacturer == "nvidia");
          isHybridNvidia = isHybrid && hasNvidia;
        in
          !isHybridNvidia;
      };
    };

    nixos = {
      host,
      config,
      ...
    }: let
      cfg = host.settings.core.hardware;
      isLaptop = cfg.deviceType == "laptop";
      inherit (cfg.nvidia) primeMode package open;

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
        hasGPUs = cfg.gpus != [];
      in
        lib.mkIf hasGPUs
        (
          cfg.gpus
          |> map (g: g.manufacturer)
        );

      hardware.nvidia =
        {
          package = config.boot.kernelPackages.nvidiaPackages.${package};
          inherit open;
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
        // lib.optionalAttrs (open && isLaptop && primeMode == "offload")
        powerManagement;
    };
  };
}
