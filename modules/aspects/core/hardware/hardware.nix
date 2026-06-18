{den, ...}: {
  den.aspects.core.hardware = {
    includes = [
      den.aspects.core.hardware.audio
      den.aspects.core.hardware.network
      den.aspects.core.hardware.bluetooth
      den.aspects.core.hardware.nvidia
    ];
  };
}
