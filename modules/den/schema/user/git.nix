{
  den.schema.user = {lib, ...}: {
    options.git = lib.mkOption {
      type = lib.types.submodule {
        options = {
          username = lib.mkOption {
            type = lib.types.str;
            example = "git";
            default = "";
            description = "Username to use for git. Will be passed to `homeManager.programs.git.settings.user.username`.";
          };
          email = lib.mkOption {
            type = lib.types.str;
            example = "git@git.com";
            default = "";
            description = "Email to use for git. Will be passed to `homeManager.programs.git.settings.user.email`.";
          };
          signingKey = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            example = "A1B2C3D4E5F6G7H8";
            # Follow upstream option default
            default = null;
            description = "Signing key consisting of 16 alphanumeric characters to use for commits. Will be passed to `homeManager.programs.git.signing.key`.";
          };
        };
      };
    };
  };
}
