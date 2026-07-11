{den, ...}: {
  den.aspects.core.hardware.essential = {
    description = ''
      Hand-picked includes for hardware stuff, excluding some proprietary and optional stuff.
      If that's the case explicitly include `den.aspects.core.hardware.$component`.
    '';

    includes = let
      inherit (den.aspects.core) hardware;
    in [
      hardware.audio
      hardware.battery
      hardware.bluetooth
      hardware.network
    ];
  };
}
