{den, ...}: {
  den.aspects.ashikaga = {
    includes = [
      den.aspects.ashikaga._
      den.aspects.core.impermanence
      den.aspects.core.impermanence.btrfs.prune-old-roots
      # Wants power-daemon instead

      den.aspects.core.display-managers.ly
      den.aspects.core.boot.limine
      den.aspects.core.nix.common
      den.aspects.core.nix.gc

      den.aspects.core.power-management.thermald
      den.aspects.extra.performance.auto-cpufreq
    ];
  };
}
