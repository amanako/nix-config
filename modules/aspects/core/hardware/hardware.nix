{den, ...}: {
  flake.den = den;

  den.aspects.core.hardware = {
    includes = [
      den.aspects.core.hardware.audio
      den.aspects.core.hardware.network
      den.aspects.core.hardware.bluetooth
      den.aspects.core.hardware.amdgpu
      den.aspects.core.hardware.nvidia
      den.aspects.core.hardware.battery
    ];
  };
}
