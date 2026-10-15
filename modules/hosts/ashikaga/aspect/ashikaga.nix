{
  den,
  lib,
  ...
}: {
  den.aspects.ashikaga = {
    includes = [
      den.aspects.ashikaga._
      den.aspects.core.impermanence
      den.aspects.core.impermanence.btrfs.prune-old-roots
      # Wants power-daemon instead

      den.aspects.security.sops-host

      den.aspects.core.display-managers.ly
      den.aspects.core.boot.limine
      den.aspects.core.nix.common

      den.aspects.core.power-management.thermald
      den.aspects.extra.performance.auto-cpufreq
      den.aspects.core.nix.nh
    ];

    nixos.boot.loader.limine.style.wallpaperStyle = "centered";

    provides.to-users = {user, ...}: {
      nixos = {host, ...}: {
        sops.secrets.user-password = let
          cfg = host.settings.security.sops-host;
        in {
          neededForUsers = true;
          key = user.userName;
          sopsFile = cfg.secretsDir + "/user-password.yaml";
        };
      };

      user = {config, ...}: {
        hashedPasswordFile = config.sops.secrets.user-password.path;
      };
    };
  };
}
