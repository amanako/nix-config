{lib, ...}: {
  den.schema.user = {
    options.isPrimaryUser = lib.mkOption {
      type = lib.types.bool;
      example = true;
      description = ''
        Whether this user is a primary user of the system.
        This option must be configured since an assertion fails.
      '';
    };
  };
}
