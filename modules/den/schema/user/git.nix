{den, ...}: {
  den = {
    schema.user = {lib, ...}: {
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
              type = lib.types.str;
              example = "A1B2C3D4E5F6G7H8";
              default = "";
              description = "Signing key consisting of 16 alphanumeric characters to use for commits. Will be passed to `homeManager.programs.git.signing.key`.";
            };
          };
        };
      };
    };

    default.includes = [den.aspects.git];

    aspects.git.homeManager = {user, ...}: {
      programs.git = {
        settings = {
          user.name = user.git.username;
          user.email = user.git.email;
        };
        signing.key = user.git.signingKey;
      };
    };
  };
}
