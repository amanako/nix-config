{
  noctalia.settings.idle = {
    hm.programs.noctalia.settings.idle.pre_action_fade_seconds = 1.0;

    hm.programs.noctalia.settings.idle.behavior.lock = {
      action = "lock";
      enabled = true;
      timeout = 600;
    };

    hm.programs.noctalia.settings.idle.behavior.screen-off = {
      action = "screen_off";
      enabled = true;
      timeout = 300;
    };
  };
}
