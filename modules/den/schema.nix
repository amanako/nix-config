{
  den.schema.host = {
    host,
    lib,
    config,
    ...
  }: {
    options = {
      deviceType = lib.mkOption {
        type = lib.types.enum [
          "unspecified"
          "desktop"
          "laptop"
          "server"
        ];
        default = "unspecified";
        description = "Device on which host resides.";
        example = "server";
      };

      timeZone = lib.mkOption {
        type = lib.types.str;
        default = "UTC";
        description = "Define time zone";
      };

      batteryID = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = ''
          Option named native-path assigned to batteries of pcs and laptops.
          Can be obtained by running `upower -b | grep -E 'vendor|model|native-path'`
          Currently used by ly display manager to display battery percentage.
        '';
      };

      gpus = lib.mkOption {
        type = lib.types.listOf (
          lib.types.submodule {
            options.type = lib.mkOption {
              type = lib.types.enum [
                "nvidia"
                "amd"
                "intel"
              ];
              description = ''
                The GPU vendor/type.
              '';
              example = "nvidia";
            };

            options.busId = lib.mkOption {
              type = lib.types.str;
              default = "";
              description = ''
                PCI bus ID for the GPU.
                Can be obtained by running: nix shell nixpkgs#pciutils -c lspci -D -d ::03xx
                Reference: https://nixos.wiki/wiki/Nvidia#Configuring_Optimus_PRIME:_Bus_ID_Values_.28Mandatory.29
              '';
              example = "PCI:1:0:0";
            };
          }
        );
        default = [];
        description = ''
          List of GPUs available on the system.
          Each entry specifies a GPU vendor and its PCI bus ID.
          Mainly made for laptops. Desktop user's should just set wantsNvidiaSupport.
        '';
        example = [
          {
            type = "intel";
            busId = "PCI:0@0:2:0";
          }
          {
            type = "nvidia";
            busId = "PCI:5@1:0:0";
          }
        ];
      };

      wantsNvidiaSupport = lib.mkOption {
        type = lib.types.bool;
        readOnly = config.deviceType != "desktop";
        default =
          if host.deviceType == "desktop"
          then false
          else lib.any (gpu: gpu.type == "nvidia" && gpu.busId != "") host.gpus;
        description = ''
          Whether to enable nvidia support.
          Automatically enabled if a nvidia GPU is configured with a busId.
        '';
        example = true;
      };

      impermanence = let
        defaultPersysDir = "/nix/persist/system";
      in
        lib.mkOption {
          type = lib.types.submodule {
            options.enable = lib.mkOption {
              type = lib.types.bool;
              default = config.impermanence.persistenceDir != defaultPersysDir;
              description = "Whether to enable impermanence module";
            };

            options.persistenceDir = lib.mkOption {
              type = lib.types.str;
              default = defaultPersysDir;
              description = "Directory for impermanence persistent storage";
            };
          };
        };

      disko.devices = lib.mkOption {
        type = lib.types.attrs;
        description = "Disko device configuration";
        default = {};
      };

      keyboardLightScript = lib.mkOption {
        type = lib.types.submodule {
          options.device = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = "Keyboard light device name. Can be obtained via `nix run nixpkgs#brightnessctl -- -l`";
            example = "asus::kbd_backlight";
          };
          options.step = lib.mkOption {
            type = lib.types.int;
            default = 1;
            description = "Step to increase/decrease brightness on each script run";
            example = 5;
          };
        };
        description = ''
          Options passed to script created as `keyboard-light` executable taking increment and decrement parameters,
          tasked with changing keyboard backlight brightness on supported devices.
        '';
      };
    };
  };
}
