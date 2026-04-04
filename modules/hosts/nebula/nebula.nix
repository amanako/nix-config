{ den, ... }:

{
  den.aspects.nebula = {
    includes = [
      (den._.unfree [
        "steam"
        "steam-unwrapped"
        "nvidia-x11"
        "nvidia-settings"
        "unrar"
      ])
      den._.hostname
      den.aspects.nebula._.hardware

      den.aspects.performance
      den.aspects.system
      den.aspects.utility
    ];

    nixos = {
      time.timeZone = "Europe/Paris";
      i18n.defaultLocale = "en_US.UTF-8";
      home-manager.useGlobalPkgs = true;
    };
  };
}
