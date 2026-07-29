{den, ...}: {
  den.aspects.cachy.hardware = {
    includes = [
      den.aspects.core.hardware.common
      den.aspects.core.disks.disko
      den.aspects.core.disks.root-btrfs
      den.aspects.core.disks.swap-subvol
      den.aspects.core.hardware.nvidia
      den.aspects.extra.performance.cachyos-kernel
    ];
  };
}
