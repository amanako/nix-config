{
  den.schema.host = {
    host,
    lib,
    ...
  }: {
    options.impermanence = lib.mkOption {
      type = lib.types.submodule {
        options = {
          enableUser = let
            hasUsers = builtins.length (lib.attrValues host.users) > 0;
          in
            lib.mkOption {
              default = hasUsers;
              example = true;
              type = lib.types.bool;
              description = ''
                Whether to enable impermanence module for users, that is impermanence for `/home` directory.
                Note that for this option to work `/home` must be an existing mountpoint marked as neededForBoot,
                which is done automatically when `den.aspects.core.impermanence` aspect is included.
              '';
            };

          persistenceDir = lib.mkOption {
            default = "/nix/persist/system";
            example = "/persist";
            type = lib.types.nullOr lib.types.path;
            description = "Directory for impermanence persistent storage";
          };
        };
      };
    };
  };
}
