{den, ...}: {
  den.aspects.ashikaga = {
    includes = [
      den.aspects.ashikaga._
      den.aspects.core.impermanence
      # Wants power-daemon instead

      den.aspects.core.display-managers.ly
      den.aspects.core.boot.tweaks.silent
      den.aspects.core.boot.tweaks.plymouth
      den.aspects.core.boot.limine
      den.aspects.core.nix
      den.aspects.core.nix.lix
    ];
  };
}
