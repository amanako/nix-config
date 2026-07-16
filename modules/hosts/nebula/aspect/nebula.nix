{den, ...}: {
  den.aspects.nebula = {
    includes = [
      den.aspects.nebula._

      den.aspects.extra.stylix
      den.aspects.core.impermanence

      den.aspects.core.boot.limine
      den.aspects.core.boot.limine.secure-boot
      den.aspects.core.boot.tweaks.plymouth
      den.aspects.core.boot.tweaks.silent

      den.aspects.core.display-managers.ly
      den.aspects.core.power-management.tlp

      den.aspects.core.nix.common
      den.aspects.core.nix.lix

      den.aspects.security.sops-host
    ];

    nixos.boot.loader.limine.style.wallpaperStyle = "centered";
  };
}
