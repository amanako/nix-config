{ inputs, ... }:

{
  flake.modules.nixos.nebula-hw =
    { pkgs, ... }:
    {
      imports = with inputs.self.modules.nixos; [
        limine
        upower
        auto-cpufreq
        thermald
        pipewire
        networkmanager
        bluetooth
        graphics
      ];
      boot.initrd.availableKernelModules = [
        "nvme"
        "xhci_pci"
      ];
      boot.initrd.kernelModules = [ ];
      boot.kernelPackages = pkgs.linuxPackages_zen;
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
    };
}
