{den, ...}: {
  den.aspects.cachy.hardware = {
    includes = [
      den.aspects.core.hardware
      den.aspects.core.disko
      den.aspects.core.nix-cachyos-kernel
    ];

    nixos = {pkgs, ...}: {
      boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-bore-zen4;
    };
  };
}
