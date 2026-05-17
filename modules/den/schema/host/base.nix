{
  __findFile,
  den,
  lib,
  ...
}: {
  den.schema = {
    host.includes = [
      <den.batteries.hostname>
      <timezone>
    ];

    host.options = {
      timeZone = lib.mkOption {
        type = lib.types.str;
        default = "UTC";
        description = "Define time zone";
      };

      deviceType = lib.mkOption {
        type = lib.types.enum [
          "unspecified"
          "desktop"
          "laptop"
          "server"
        ];
        default = "unspecified";
        description = "Device on which host resides.";
        example = "server";
      };
    };
  };

  den.aspects.timezone.nixos = {host, ...}: {
    time.timeZone = host.timeZone or "UTC";
  };
}
