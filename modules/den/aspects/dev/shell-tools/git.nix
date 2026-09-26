{lib, ...}: {
  den.aspects.dev.shell-tools.git = let
    inherit
      (lib)
      mkOption
      types
      ;
  in {
    description = "Distributed version control system configuration.";

    userSettings = {
      username = mkOption {
        type = types.str;
        default = "";
        example = "git";
        description = "Username to use for git. Will be passed to `homeManager.programs.git.settings.user.username`.";
      };

      email = mkOption {
        type = types.str;
        default = "";
        example = "git@git.com";
        description = "Email to use for git. Will be passed to `homeManager.programs.git.settings.user.email`.";
      };

      signingKey = mkOption {
        type = types.nullOr types.str;
        # Follow upstream option default
        default = null;
        example = "A1B2C3D4E5F6G7H8";
        description = "Signing key consisting of 16 alphanumeric characters to use for commits. Will be passed to `homeManager.programs.git.signing.key`. Optionally can be left out.";
      };
    };

    hm = {user, ...}: let
      cfg = user.settings.dev.shell-tools.git;
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
