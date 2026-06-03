{inputs, ...}: {
  flake-file.inputs.dms-plugin-registry.url = "github:AvengeMedia/dms-plugin-registry";

  dms.plugins.general = {
    homeManager = {
      imports = [
        inputs.dms-plugin-registry.modules.default
      ];

      # Generally useful plugins
      programs.dank-material-shell.plugins = {
        dankBatteryAlerts.enable = true;
        dankHooks.enable = true;
        dankActions.enable = true;
      };
    };
  };
}
