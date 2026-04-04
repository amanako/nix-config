{ den, inputs, ... }:

{
  flake-file.inputs = {
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence = {
      url = "github:nix-community/impermanence";
    };
  };

  den.aspects.hardware = {
    # TODO: Add conditional based on host configuration
    includes = [
      den.aspects.nvidia
    ];

    provides.with-disko = {
      nixos = {
        imports = [ inputs.disko.nixosModules.disko ];
      };
    };

    provides.with-impermanence = {
      nixos = {
        imports = [ inputs.impermanence.nixosModules.impermanence ];
      };
    };

    nixos = {
      services.pipewire = {
        enable = true;
        alsa = {
          enable = true;
          support32Bit = true;
        };
        pulse.enable = true;
      };

      hardware.bluetooth.enable = true;
      hardware.bluetooth.powerOnBoot = true;

      networking.networkmanager.enable = true;

      boot.loader.efi.canTouchEfiVariables = true;
      boot.loader.limine = {
        enable = true;
        # Limine may fill up quickly
        maxGenerations = 5;
        efiSupport = true;
        enableEditor = true;
      };
    };
  };
}
