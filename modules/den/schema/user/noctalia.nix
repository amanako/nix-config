{
  den.schema.user = {
    lib,
    config,
    ...
  }: {
    options.noctalia-shell = lib.mkOption {
      type = lib.types.submodule {
        options.additionalSettings = lib.mkOption {
          example = {
            currentThemeName = "gruvbox";
            showDock = true;
            controlCenterWidgets = [
              {
                id = "wifi";
                enabled = false;
                width = 100;
              }
            ];
          };
          default = {};
          type = lib.types.attrs;
          description = "Settings to append to defaults, overriding if necessary.";
        };

        options.pfpName = lib.mkOption {
          example = "my_pfp";
          default = ".face";
          type = lib.types.str;
          description = ''
            Name to use for the avatar image without extension shown in noctalia settings for example.
            The path is currently immutable at `${config.repoRoot}/assets/users/${config.noctalia-shell.userName}`.
          '';
        };
      };
    };
  };
}
