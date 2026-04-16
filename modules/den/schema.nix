{
  den.schema.host =
    { lib, ... }:
    {
      options.timeZone = lib.mkOption {
        type = lib.types.str;
        default = "UTC";
        description = "Host time zone.";
      };

      options.impermanence = lib.mkOption {
        type = lib.types.submodule {
          options.persistence-dir = lib.mkOption {
            type = lib.types.str;
            default = "/nix/persist/system";
            description = "Directory for impermanence persistent storage";
          };
        };
        default = { };
      };
    };
}
