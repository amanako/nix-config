{ den, ... }:

{
  den.aspects.nebula = {
    includes = [
      den._.hostname
      (den._.unfree [
        "nvidia-x11"
        "nvidia-settings"
        "steam"
        "steam-unwrapped"
        "rar"
        "unrar"
      ])
      den.aspects.nebula._.hardware

      den.aspects.performance
      den.aspects.system
      den.aspects.utility
    ];

    nixos =
      { lib, ... }:
      {
        home-manager.useGlobalPkgs = true;
        time.timeZone = "Europe/Paris";
        i18n.defaultLocale = "en_US.UTF-8";
      };
  };
}
