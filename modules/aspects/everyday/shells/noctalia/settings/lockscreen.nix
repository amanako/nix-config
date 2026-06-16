{
  noctalia.settings.lockscreen = {
    homeManager.programs.noctalia.settings.lockscreen = {
      blurred_desktop = true;
    };
  };

  noctalia.settings.lockscreen_widgets = {
    homeManager.programs.noctalia.settings.lockscreen_widgets = {
      enabled = true;
      schema_version = 2;
      widget_order = ["lockscreen-login-box@eDP-1" "lockscreen-widget-0000000000000001"];

      grid = {
        cell_size = 16;
        major_interval = 4;
        visible = true;
      };

      widget = {
        "lockscreen-login-box@eDP-1" = {
          box_height = 0.0;
          box_width = 0.0;
          cx = 960.0;
          cy = 957.0;
          output = "eDP-1";
          rotation = 0.0;
          type = "login_box";

          settings = {
            background_color = "surface_variant";
            background_opacity = 0.88;
            background_radius = 12.0;
            input_opacity = 1.0;
            input_radius = 6.0;
            show_login_button = true;
          };
        };
        "lockscreen-widget-0000000000000001" = {
          box_height = 272.0;
          box_width = 576.0;
          cx = 1508.0;
          cy = 372.0;
          output = "eDP-1";
          rotation = 0.0;
          type = "weather";

          settings = {
            background_opacity = 0.59;
            color = "on_surface";
            forecast_days = 5;
            show_forecast = true;
          };
        };
      };
    };
  };
}
