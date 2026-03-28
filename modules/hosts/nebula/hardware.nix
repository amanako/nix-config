{ den, ... }:

{
  den.aspects.nebula._.hardware = {
    includes = [
      den.aspects.hardware
    ];

    nixos =
      {
        pkgs,
        lib,
        modulesPath,
        ...
      }:
      {
        # Without adding this modulesPath AMD and bluetooth service fail to start
        # With message hardware initialization failed
        # EDIT: After adding facter.json report below it seems OK to remove this line
        # Anyhow, you may wish to uncomment in case of hardware failure (and above)
        imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

        hardware.facter.reportPath = ./facter.json;

        boot.initrd.availableKernelModules = [
          "nvme"
          "xhci_pci"
        ];

        # I like to use zen packages buy it may be changed
        boot.kernelPackages = pkgs.linuxPackages_latest;

        boot.initrd.kernelModules = [ ];
        boot.kernelModules = [ "kvm-amd" ];
        boot.extraModulePackages = [ ];

        swapDevices = [ ];
        nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

        fileSystems."/" = {
          device = "/dev/disk/by-uuid/d720667a-89c7-472d-9ee4-68c52e48878f";
          fsType = "ext4";
        };

        fileSystems."/boot" = {
          device = "/dev/disk/by-uuid/C192-78A7";
          fsType = "vfat";
          options = [
            "fmask=0077"
            "dmask=0077"
          ];
        };
      };
  };
}
