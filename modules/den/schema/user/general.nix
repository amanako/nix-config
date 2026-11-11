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
        type = types.nullOr types.path;
        default = host.repoRoot;
        example = "/home/user/nix-config";
        description = ''
          Root folder of repository where flake resides. Corresponding option of `host.repoRoot`.
          Optional; inherits `host.repoRoot` by default, which may be null while unset.
          Read-only unless `isPrimaryUser` is true, so only a primary user can override the host value.
          Set it (on the host or here) when included aspects need to read files from the repository.
        '';
        readOnly = !config.isPrimaryUser;
      };
    };
  };
}
