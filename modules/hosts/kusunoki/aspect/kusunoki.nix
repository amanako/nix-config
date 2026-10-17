{den, ...}: {
  den.aspects.kusunoki = {
    includes = [
      den.aspects.kusunoki._

      den.aspects.extra.stylix
      den.aspects.core.impermanence
      den.aspects.core.impermanence.btrfs.prune-old-roots

      den.aspects.core.boot.limine.with-secure-boot

      den.aspects.core.display-managers.ly
      den.aspects.core.power-management.tlp
      den.aspects.core.power-management.thermald

      den.aspects.core.nix.common
      den.aspects.core.nix.lix
      den.aspects.core.nix.nh

      den.aspects.security.sops-host
      den.aspects.security.tailscale
    ];

    nixos.boot.loader.limine.style.wallpaperStyle = "centered";
  };
}
