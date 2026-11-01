{den, ...}: {
  den.aspects.ashikaga.hardware = {
    includes = [
      den.aspects.core.hardware.common
      den.aspects.core.disks.disko
      den.aspects.core.disks.esp
      den.aspects.core.disks.root-btrfs
      den.aspects.core.disks.swap
      den.aspects.core.disks.zram
      den.aspects.core.hardware.nvidia
      den.aspects.core.hardware.amdgpu
      den.aspects.extra.performance.cachyos-kernel
    ];
  };
}
