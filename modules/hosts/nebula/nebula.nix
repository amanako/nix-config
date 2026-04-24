{ den, ... }:

{
  den.aspects.nebula = {
    includes = with den.aspects; [
      nebula._.hardware

      performance
      utility
      displayManagers._.ly
      nvidia
      boot
    ];
  };
}
