{lib, ...}: {
  den.schema.host = {host, ...}: {
    options.impermanence = lib.mkOption {
      type = lib.types.submodule {
        options = {
          enableSystem = lib.mkOption {
            default = host.impermanence.persistenceDir != null;
            example = true;
            type = lib.types.bool;
            description = ''
              Whether to enable impermanence module for the host system.
              This option is implicitly enabled when persistenceDir is set.
            '';
          };

          enableHome = lib.mkOption {
            default = false;
            example = true;
            type = lib.types.bool;
            description = ''
              Whether to enable impermanence module for users, that is in /home directory.
              Note that for this option to work `/home` must be an existing mountpoint marked as neededForBoot,
              which is done automatically.
            '';
          };

          persistenceDir = lib.mkOption {
            default = null;
            example = "/nix/persist/system";
            type = lib.types.nullOr lib.types.path;
            description = "Directory for impermanence persistent storage";
          };
        };
      };
    };
  };
}
