{lib, ...}: {
  den.schema.user = {
    host,
    config,
    ...
  }: {
    options = let
      inherit
        (lib)
        mkOption
        types
        ;
    in {
      preferences = mkOption {
        type = types.submodule {
          options = let
            mkPrefOption = pref: {
              example ? "",
              description ? "Preferred ${pref} binary name.",
            }:
              mkOption {
                type = lib.types.str;
                default = "";
                inherit
                  example
                  description
                  ;
              };
          in {
            editor = mkPrefOption "text editor" {
              example = "hx";
            };

            term = mkPrefOption "terminal" {
              example = "ghossty";
            };

            browser = mkPrefOption "web browser" {
              example = "firefox";
            };

            fileManager = mkPrefOption "file manager" {
              example = "thunar";
            };
          };
        };

        default = {
          editor = "hx";
          term = "alacritty";
          browser = "firefox";
          fileManager = "nemo";
        };

        example = {
          browser = "zen-beta";
          term = "kitty";
          editor = "nvim";
          fileManager = "nautilus";
        };

        description = ''
          List of common applications user would like available.
          This should be set because it will be used for keybindindings in compositors and shells and some default settings.
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
