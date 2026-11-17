{
  noctalia.settings.shell = {
    hm.programs.noctalia.settings.shell = {
      niri_overview_type_to_launch_enabled = true;
      password_style = "random";
      polkit_agent = true;
      settings_show_advanced = true;
      show_location = false;

      animation = {
        speed = 0.7;
      };

      panel = {
        transparency_mode = "glass";
        borders = true;
        shadow = true;
        launcher_placement = "floating";
        clipboard_placement = "floating";
        control_center_placement = "floating";
        wallpaper_placement = "attached";
        session_placement = "attached";
        launcher_position = "center";
        clipboard_position = "center";
        open_near_click_launcher = true;
        open_near_click_clipboard = true;
      };

      shadow = {
        direction = "right";
        alpha = 0.55;
      };
    };
  };
}
