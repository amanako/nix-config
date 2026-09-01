{den, ...}: {
  flake.den = den;
  den.aspects.nebula.hardware = {
    includes = [
      den.aspects.core.hardware.common
      den.aspects.core.hardware.nvidia
      den.aspects.core.disks.disko
      den.aspects.core.disks.root-btrfs
      den.aspects.core.disks.swap-subvol
      den.aspects.extra.performance.cachyos-kernel
    ];

    nixos = {modulesPath, ...}: {
      imports = [
        (modulesPath + "/installer/scan/not-detected.nix")
      ];

      boot.initrd.availableKernelModules = [
        "nvme"
        "xhci_pci"
      ];

      # For building raspberry pi images
      boot.binfmt.emulatedSystems = ["aarch64-linux"];

      boot = {
        kernelModules = [
          "kvm-amd"
          "btrfs"
        ];

        kernelParams = [
          # The driver will attempt to reset the GPU and continue instead of requiring a full system reboot
          "amdgpu.gpu_recovery=1"
          # Enables GPU memory retry logic
          "amdgpu.noretry=0"
          # If the GPU doesn't respond within this time(in ms), the driver will trigger the recovery mechanism
          "amdgpu.lockup_timeout=10000"
          # Watchdogs usually slowdown shutdown
          "nowatchdog"
        ];

        blacklistedKernelModules = [
          "iTCO_wdt"
          "intel_pmc_bxt"
          "iTCO_vendor_support"
          "softdog"
          "sp5100_tco"
        ];
      };
    };
  };
}
