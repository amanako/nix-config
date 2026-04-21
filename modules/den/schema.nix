{
  den.schema.host =
    { lib, config, ... }:
    {
      options.timeZone = lib.mkOption {
        type = lib.types.str;
        default = "UTC";
        description = "Define time zone";
      };

      options.impermanence =
        let
          defaultPersysDir = "/nix/persist/system";
        in
        lib.mkOption {
          type = lib.types.submodule {
            options.enable = lib.mkOption {
              type = lib.types.bool;
              default = config.impermanence.persistenceDir != defaultPersysDir;
              description = "Whether to enable impermanence module";
            };

            options.persistenceDir = lib.mkOption {
              type = lib.types.str;
              default = defaultPersysDir;
              description = "Directory for impermanence persistent storage";
            };
          };
        };

      options.disko.devices = lib.mkOption {
        type = lib.types.attrs;
        description = "Disko device configuration";
        default = { };
      };
    };
}
