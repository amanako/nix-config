{den, ...}: {
  den.aspects.nebula = {
    includes = with den.aspects; [
      nebula._.hardware
      bootloader._.limine

      boot
      performance
      displayManagers._.ly
      utility
    ];
  };
}
