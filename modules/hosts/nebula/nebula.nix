{ den, ... }:

{
  den.aspects.nebula = {
    includes = with den.aspects; [
      nebula._.hardware

      performance
      system
      utility
    ];

    nixos = {
      home-manager.backupFileExtension = "backup";
    };
  };
}
