{
  flake-file.inputs.dms-plugin-registry.url = "github:AvengeMedia/dms-plugin-registry";

  dms.plugins.general = {
    homeManager = {inputs', ...}: {
      imports = [
        inputs'.dms-plugin-registry.modules.default
      ];

      programs.dank-material-shell = {
        managePluginSettings = true;

        # Generally useful plugins
        plugins = {
          dankBatteryAlerts.enable = true;
          dankHooks.enable = true;
          dankActions.enable = true;
        };
      };
    };
  };
}
