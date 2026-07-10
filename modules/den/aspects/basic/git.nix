{lib, ...}: {
  den.aspects.basic.git = let
    inherit
      (lib)
      mkOption
      types
      ;
  in {
    userSettings = {
      username = mkOption {
        type = types.str;
        example = "git";
        default = "";
        description = "Username to use for git. Will be passed to `homeManager.programs.git.settings.user.username`.";
      };

      email = mkOption {
        type = types.str;
        example = "git@git.com";
        default = "";
        description = "Email to use for git. Will be passed to `homeManager.programs.git.settings.user.email`.";
      };

      signingKey = mkOption {
        type = types.nullOr types.str;
        example = "A1B2C3D4E5F6G7H8";
        # Follow upstream option default
        default = null;
        description = "Signing key consisting of 16 alphanumeric characters to use for commits. Will be passed to `homeManager.programs.git.signing.key`.";
      };
    };

    hm = {user, ...}: let
      cfg = user.settings.basic.git;
    in {
      programs.git = {
        enable = true;
        settings = {
          user.name = cfg.username;
          user.email = cfg.email;
        };

        signing = {
          key = cfg.signingKey;
          signByDefault = true;
        };
      };
    };
  };
}
