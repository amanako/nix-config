{lib, ...}: {
  den.schema.host = {
    options = {
      repoRoot = lib.mkOption {
        type = lib.types.path;
        example = "/etc/nixos";
        description = ''
          Root folder of repository where flake resides.
          Evaluation of this option is dependent on whether corresponding user option `user.repoRoot` is set.
          If no user is present or users haven't defined their option, assertion fails.
        '';
      };
    };
  };
}
