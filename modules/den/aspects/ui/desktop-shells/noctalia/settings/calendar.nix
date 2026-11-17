{
  noctalia.settings.calendar = {
    hm.programs.noctalia.settings = {
      calendar = {
        enabled = true;
        refresh_minutes = 15;
        event_date_format = "%A %e %B";
        event_time_format = "%H:%M";
      };

      control_center.calendar = {
        show_events_card = true;
        show_week_numbers = false;
      };

      weather = {
        enabled = true;
        refresh_minutes = 30;
        unit = "celsius";
        effects = true;
      };
    };
  };
}
