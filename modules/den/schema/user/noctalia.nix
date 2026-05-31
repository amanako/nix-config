{
  den.schema.user = {lib, ...}: {
    options.noctalia-shell.additionalSettings = lib.mkOption {
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
  };
}
