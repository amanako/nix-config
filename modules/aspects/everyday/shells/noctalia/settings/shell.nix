{
  noctalia.settings.shell = {
    homeManager.programs.noctalia.settings.shell = {
      niri_overview_type_to_launch_enabled = true;
      password_style = "random";
      polkit_agent = true;
      screen_time_enabled = true;
      settings_show_advanced = true;
      show_location = false;

      animation = {
        speed = 0.7;
      };

      panel = {
        clipboard_placement = "floating";
        control_center_placement = "centered";
        launcher_session_search = true;
        open_near_click_launcher = true;
      };

      screen_corners = {
        enabled = true;
        size = 24;
      };

      screenshot = {
        pipe_to_command = true;
      };

      shadow = {
        direction = "right";
      };
    };
  };
}
