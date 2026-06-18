{den, ...}: {
  den.aspects.nebula = {
    includes = [
      den.aspects.nebula._
      den.aspects.core.boot.limine
      den.aspects.core.boot.optional.plymouth
      den.aspects.core.boot.optional.silent
      den.aspects.performance._
      den.aspects.core.displayManagers.ly
      den.aspects.core.nix
      den.aspects.core.nix.lix
    ];

    nixos.boot.loader.limine.style.wallpaperStyle = "centered";
  };
}
