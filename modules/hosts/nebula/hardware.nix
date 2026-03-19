{ inputs, ... }:

{
  flake.modules.nixos.nebula-hw =
    {
      lib,
      modulesPath,
      ...
    }:
    {
      imports =
        with inputs.self.modules.nixos;
        [
          upower
          auto-cpufreq
          thermald
          pipewire
          networkmanager
          bluetooth
          graphics
        ]
        ++ [ (modulesPath + "/installer/scan/not-detected.nix") ];
      boot.initrd.availableKernelModules = [
        "nvme"
        "xhci_pci"
      ];
      boot.initrd.kernelModules = [ ];
      boot.kernelModules = [ "kvm-amd" ];
      boot.extraModulePackages = [ ];

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

      swapDevices = [ ];
      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    };
}
