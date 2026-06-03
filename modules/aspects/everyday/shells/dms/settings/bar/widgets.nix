{
  dms.bar.widgets = {
    homeManager = {
      lib,
      config,
      ...
    }: {
      programs.dank-material-shell.settings = {
        leftWidgets =
          [
            {
              id = "music";
              enabled = true;
              mediaSize = 2;
            }
            {
              id = "clock";
              enabled = true;
              clockCompactMode = true;
            }
            {
              id = "weather";
              enabled = true;
            }
          ]
          ++ lib.optional
          (lib.hasAttr "nix-monitor" config.programs && config.programs.nix-monitor.enable)
          {
            id = "nixMonitor";
          };
        centerWidgets = [
          "systemTray"
          "battery"
          "controlCenterButton"
          {
            id = "cpuUsage";
            enabled = true;
            minimumWidth = true;
          }
          {
            id = "memUsage";
            enabled = true;
            minimumWidth = true;
          }
        ];
        rightWidgets = [
          "workspaceSwitcher"
          "launcherButton"
        ];
      };
    };
  };
}
