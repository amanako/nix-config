{
  noctalia.settings.widget = {
    hm.programs.noctalia.settings.widget = {
      battery = {
        display_mode = "graphic";
        show_label = false;
      };

      clipboard = {
        glyph = "clipboard-search";
      };

      clock = {
        capsule_opacity = 0.67;
        color = "secondary";
        font_weight = 500;
        format = "{:%H:%M %a, %d %b}";
        vertical_format = "{:%H\n%M}";
        tooltip_format = "{:%A, %d %B %Y}";
      };

      notifications = {
        hide_when_no_unread = true;
      };

      cpu = {
        type = "sysmon";
        stat = "cpu_usage";
        visualization = "gauge";
        show_value = false;
        show_glyph = true;
      };

      launcher = {
        glyph = "a-b";
      };

      media = {
        min_length = 40;
        title_scroll = "always";
      };

      ram = {
        type = "sysmon";
        stat = "ram_pct";
        visualization = "gauge";
        show_value = false;
        show_glyph = true;
      };

      temp = {
        type = "sysmon";
        stat = "cpu_temp";
        visualization = "gauge";
        show_value = false;
        show_glyph = true;
      };

      tray = {
        drawer = false;
      };

      workspaces = {
        capsule_opacity = 0.5;
        style = "minimal";
        show_labels = true;
        label_source = "name";
        occupied_color = "tertiary";
      };
    };
  };
}
