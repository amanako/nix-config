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
        description = "Device on which host resides.";
        example = "server";
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
              description = ''
                The GPU manufacturer.
              '';
              example = "nvidia";
            };

            options.busId = mkOption {
              default = "";
              example = "PCI:1:0:0";
              type = types.strMatching "([[:print:]]+:[0-9]{1,3}(@[0-9]{1,10})?:[0-9]{1,2}:[0-9])?";
              description = ''
                PCI bus ID for the GPU.
                Can be obtained by running: nix shell nixpkgs#pciutils -c lspci -D -d ::03xx
                Reference: https://nixos.wiki/wiki/Nvidia#Configuring_Optimus_PRIME:_Bus_ID_Values_.28Mandatory.29
              '';
            };
          }
        );

        default = [];
        description = ''
          List of GPUs available on the system.
          Each entry specifies a GPU manufacturer and its PCI bus ID.
          Mainly made for laptops. Desktop users may just include .
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
    };
  };
}
