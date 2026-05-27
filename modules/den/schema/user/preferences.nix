{
  den.schema.user = {
    lib,
    config,
    host,
    ...
  }: {
    options = {
      preferences = lib.mkOption {
        type = lib.types.submodule {
          options = let
            mkPrefOption = pref: {
              example ? "",
              description ? "Prefered ${pref} binary name.",
            }:
              lib.mkOption {
                inherit example description;
                type = lib.types.str;
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
      };

      repoRoot = lib.mkOption {
        default = host.repoRoot;
        example = "/home/user/nix-config";
        readOnly = config.isPrimaryUser == false;
        type = lib.types.path;
        description = ''
          Root folder of repository where flake resides. Corresponding option of `host.repoRoot`
          This in inherited from host by default and is readonly if user is not primary, that is if isPrimaryUser option is false.
          Otherwise, setting this option for all users present on host alleviates host the need to set it themself.
        '';
      };

      default = {};
    };
  };
}
