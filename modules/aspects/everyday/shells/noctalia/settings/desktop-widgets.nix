{
  noctalia.settings.desktopWidgets = {
    homeManager.programs.noctalia.settings.desktopWidgets = {
      enabled = false;
      monitorWidgets = [];
    };
  };

  noctalia.settings.desktop_widgets = {
    homeManager.programs.noctalia.settings.desktop_widgets = {
      schema_version = 2;
      widget_order = ["desktop-widget-0000000000000001"];

      grid = {
        cell_size = 16;
        major_interval = 4;
        visible = true;
      };

      widget = {
        desktop-widget-0000000000000001 = {
          box_height = 304.0;
          box_width = 528.0;
          cx = 1576.0;
          cy = 340.0;
          output = "eDP-1";
          rotation = 0.0;
          type = "sysmon";

          settings = {
            background_color = "on_hover";
            color = "primary";
            color2 = "secondary";
            stat = "cpu_usage";
            stat2 = "ram_pct";
          };
        };
      };
    };
  };
}
