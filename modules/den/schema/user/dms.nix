{
  den.schema.user = {lib, ...}: {
    options.dank-material-shell = lib.mkOption {
      type = lib.types.submodule {
        options.additionalSessionSettings = lib.mkOption {
          example = {
            isLightMode = true;
            latitude = 40.7128;
            weatherCoordinates = "40.7128,-74.0060";
          };
          default = {};
          type = lib.types.attrs;
          description = ''
            User session to append to default session configuration, overriding if necessary.
            Passed to `homeManager.programs.dank-material-shell.session`.
          '';
        };

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
          description = ''
            User settings to append to default settings, overriding if necessary.
            Passed to `homeManager.programs.dank-material-shell.settings`.;
          '';
        };
      };
    };
  };
}
