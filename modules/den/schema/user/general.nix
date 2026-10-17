{lib, ...}: let
  inherit
    (lib)
    mkOption
    types
    ;
in {
  den.schema.user = {
    host,
    config,
    ...
  }: {
    options = {
      isPrimaryUser = mkOption {
        type = types.bool;
        example = true;
        description = ''
          Whether this user is a primary user of the system.
          This option must be configured since an assertion fails.
        '';
      };

      repoRoot = mkOption {
        type = types.path;
        default = host.repoRoot;
        example = "/home/user/nix-config";
        description = ''
          Root folder of repository where flake resides. Corresponding option of `host.repoRoot`
          This in inherited from host by default and is readonly if user is not primary, that is if isPrimaryUser option is false.
          Otherwise, setting this option for all users present on host alleviates host the need to set it themself.
        '';
        readOnly = !config.isPrimaryUser;
      };
    };
  };
}
