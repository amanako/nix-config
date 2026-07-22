{
  den,
  lib,
  ...
}: {
  # Jujutsu is tightly related to git (even having git as a dependency).
  # Inherit profile defaults from git if set.
  den.aspects.dev.shell-tools.jujutsu = {
    description = ''
      A Git-compatible VCS(version control system) that is both simple and powerful.
    '';

    userSettings = {user, ...}: let
      inherit (lib) mkOption types;
    in {
      username = mkOption {
        default =
          user.settings.dev.shell-tools.git.username
          |> lib.optionalString (den.aspects.dev.shell-tools.git |> user.hasAspect);
        example = "git";
        type = types.str;
        description = "Name to use for jj version control system";
      };

      email = mkOption {
        default =
          user.settings.dev.shell-tools.git.email
          |> lib.optionalString (den.aspects.dev.shell-tools.git |> user.hasAspect);
        type = types.str;
        description = "Email to use for jj version control system";
      };

      signing = mkOption {
        default = {
          backend = "none";
          key = "";
        };
        type = types.submodule {
          options = {
            backend = mkOption {
              default = "none";
              example = "ssh";
              type = types.enum [
                "none"
                "gpg"
                "ssh"
              ];
              description = "Backend to use for signing commits. None to disable signing.";
            };

            key = mkOption {
              default = "";
              example = "4ED556E9729E000F";
              type = types.str;
              description = "Signing key to use for signing commits.";
            };
          };
        };
      };
    };

    hm = {user, ...}: let
      cfg = user.settings.dev.shell-tools.jujutsu;
    in {
      programs.jujutsu = {
        enable = true;
        settings = {
          ui.color = "always";
          commit_id = "green";

          user = {
            name = cfg.username;
            email = cfg.email;
          };

          signing = {
            inherit (cfg.signing) backend key;
            behaviour = "own"; # Sign commits created or edited by user
          };
        };
      };
    };
  };
}
