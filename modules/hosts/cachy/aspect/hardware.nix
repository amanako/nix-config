{den, ...}: {
  den.aspects.cachy.hardware = {
    includes = [
      den.aspects.core.hardware.essential
      den.aspects.core.hardware.disko
      den.aspects.core.hardware.nvidia
      den.aspects.core.nix-cachyos-kernel
    ];
  };
}
