{den, ...}: {
  den.aspects.nebula = {
    includes = [
      den.aspects.nebula._
      den.aspects.optional.stylix
      den.aspects.core.impermanence
      den.aspects.core.boot.limine
      den.aspects.core.boot.optional.plymouth
      den.aspects.core.boot.optional.silent
      den.aspects.core.displayManagers.ly
      den.aspects.core.nix
    ];

    nixos.boot.loader.limine.style.wallpaperStyle = "centered";
  };
}
