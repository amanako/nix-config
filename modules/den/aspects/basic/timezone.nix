{lib, ...}: {
  den.aspects.basic.time = {
    description = ''
      Configuration aspect for host timezone.
    '';

    hostSettings = {
      timeZone = lib.mkOption {
        type = lib.types.str;
        default = "UTC";
        example = "Poland/Warsaw";
        description = "Define time zone.";
      };
    };

    nixos = {host, ...}: let
      cfg = host.settings.basic.time;
    in {
      time.timeZone = cfg.timeZone;
    };
  };
}
