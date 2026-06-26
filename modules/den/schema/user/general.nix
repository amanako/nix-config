{
  lib,
  __findFile,
  ...
}: {
  den.schema.user = {
    options.isPrimaryUser = lib.mkOption {
      example = true;
      type = lib.types.bool;
      description = ''
        Whether this user is a primary user of the system.
        This option must be configured, instead assertion fails.
      '';
    };
  };
}
