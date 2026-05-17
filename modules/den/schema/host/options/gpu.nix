{
  den.schema.host = {
    host,
    lib,
    config,
    ...
  }: {
    options = {
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
    };
  };
}
