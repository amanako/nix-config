{lib, ...}: {
  den.aspects.wallpaper-managers.awww.userSettings = {user, ...}: let
    inherit
      (lib)
      mkOption
      types
      ;
    cfg = user.settings.wallpaper-managers.awww;
  in {
    service = mkOption {
      type = types.submodule {
        options = {
          label = mkOption {
            type = types.str;
            default = cfg.script.label;
            example = "awww-rand-service";
            description = ''
              Name to use for the service.
              Defaults to the script label (`user.settings.wallpaper-managers.awww.script.label`)
              as it's recommended keeping it the same as the script name for convenience.
            '';
          };

          interval = mkOption {
            type = types.nullOr types.str;
            default =
              if cfg.service.calendar == null
              then "30min"
              else null;
            example = "2h";
            description = ''
              Value for systemd's OnUnitActiveSec. Fires this long after the initial activation.
              Defaults to `30min` when no `calendar` is set, otherwise `null`.
              Reference https://www.freedesktop.org/software/systemd/man/latest/systemd.time.html.
            '';
          };

          calendar = mkOption {
            type = types.nullOr types.str;
            default = null;
            example = "daily";
            description = ''
              Value for systemd's OnCalendar to fire the script.
              When both this option and `user.settings.wallpaper-managers.awww.service.interval` are set, the timer fires when EITHER condition is met.
              Reference https://www.freedesktop.org/software/systemd/man/latest/systemd.timer.html.
            '';
          };
        };
      };
    };
  };
}
