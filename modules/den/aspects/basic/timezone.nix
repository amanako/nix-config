{lib, ...}: {
  den.aspects.basic.time = {
    hostSettings = {
      timeZone = lib.mkOption {
        type = lib.types.str;
        default = "UTC";
        description = "Define time zone";
      };
    };

    nixos = {host, ...}: {
      time.timeZone = host.settings.basic.time.timeZone;
    };
  };
}
