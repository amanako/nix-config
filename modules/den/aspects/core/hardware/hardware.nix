{lib, ...}: {
  den.aspects.core.hardware = let
    inherit
      (lib)
      mkOption
      types
      ;
  in {
    hostSettings = {
      deviceType = mkOption {
        type = types.enum [
          "unspecified"
          "desktop"
          "laptop"
          "server"
        ];
        default = "unspecified";
        example = "server";
        description = "Device on which host resides.";
      };

      gpus = mkOption {
        type = types.listOf (
          types.submodule {
            options.manufacturer = mkOption {
              type = types.enum [
                "nvidia"
                "amdgpu"
                "intel"
              ];
              example = "nvidia";
              description = ''
                The GPU manufacturer.
              '';
            };

            options.busId = mkOption {
              type = types.strMatching "([[:print:]]+:[0-9]{1,3}(@[0-9]{1,10})?:[0-9]{1,2}:[0-9])?";
              default = "";
              example = "PCI:1:0:0";
              description = ''
                PCI bus ID for the GPU.
                Can be obtained by running: nix shell nixpkgs#pciutils -c lspci -D -d ::03xx
                Reference: https://nixos.wiki/wiki/Nvidia#Configuring_Optimus_PRIME:_Bus_ID_Values_.28Mandatory.29.
              '';
            };
          }
        );

        default = [];
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

        description = ''
          List of GPUs available on the system.
          Each entry specifies a GPU manufacturer and its PCI bus ID.
          This option is transformed and passed to `services.xserver.videoDrivers` so it should represent order of trial of gpus on boot.
          On laptops it is recommended keeping nvidia last.
          Mainly made for laptops. Desktop users may just include `den.aspects.core.hardware.nvidia` aspect.
        '';
      };
    };
  };
}
