{den, ...}: {
  den.aspects.cachy = {
    includes = [
      den.aspects.cachy._
      den.aspects.core.impermanence
      # Wants power-daemon instead

      den.aspects.core.boot.optional.silent
      den.aspects.core.boot.optional.plymouth
      den.aspects.core.boot.limine
      den.aspects.core.nix
      den.aspects.core.nix.lix
    ];
  };
}
