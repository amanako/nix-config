{lib, ...}: let
  inherit
    (lib)
    mkOption
    types
    ;
in {
  # Jujutsu is tightly related to git (even having git as a dependency).
  # Inherit profile defaults from git if set.
  den.aspects.dev.tools.jujutsu = {
    description = ''
      A Git-compatible VCS(version control system) that is both simple and powerful.
    '';

    userSettings = {user, ...}: let
      cfg = user.settings;
    in {
      username = mkOption {
        # Attempt to configure from git credentials if configuration if present.
        default = cfg.dev.tools.git.username or "";
        example = "git";
        type = types.str;
        description = "Name to use for jj version control system";
      };

      email = mkOption {
        default = cfg.dev.tools.git.email or "";
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

    # Per-repo configuration.
    persistUser.directories = let
      basePath = ".config/jj";
    in
      [
        "repos"
        "workspaces"
      ]
      |> map (f: "${basePath}/${f}");

    hm = {user, ...}: let
      cfg = user.settings.dev.tools.jujutsu;
    in {
      programs.jujutsu = {
        enable = true;
        settings = {
          ui.color = "always";
          commit_id = "green";

          user = {
            name = cfg.username;
            inherit (cfg) email;
          };

          signing = {
            inherit (cfg.signing) backend key;
            behavior = "own"; # Sign commits created or edited by user
          };
        };
      };
    };
  };
}
