{
  noctalia.settings.idle = {
    hm.programs.noctalia.settings.idle = {
      behavior_order = ["screen-off" "lock" "lock-and-suspend"];
      customCommands = "[]";
      enabled = true;
      fadeDuration = 10;
      lockCommand = "";
      lockTimeout = 600;
      resumeLockCommand = "";
      resumeScreenOffCommand = "";
      resumeSuspendCommand = "";
      screenOffCommand = "";
      screenOffTimeout = 300;
      suspendCommand = "";
      suspendTimeout = 600;

      behavior = {
        lock = {
          action = "lock";
          enabled = true;
          timeout = 600;
        };
        lock-and-suspend = {
          action = "lock_and_suspend";
          enabled = true;
          timeout = 900;
        };
        screen-off = {
          action = "screen_off";
          enabled = true;
          timeout = 300;
        };
      };
    };
  };
}
