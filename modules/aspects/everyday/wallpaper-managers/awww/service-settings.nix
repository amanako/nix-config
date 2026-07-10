{lib, ...}: {
  den.aspects.wallpaper-managers.awww.userSettings = let
    inherit
      (lib)
      mkOption
      types
      ;
  in {
    service = mkOption {
      type = types.submodule {
        options = {
          label = mkOption {
            default = "awww-randomizer";
            example = "awww-rand-service";
            type = types.str;
            description = ''
              Name to use for the service.
              Recommended keeping it the same as script name for convenience.
            '';
          };

          interval = mkOption {
            default = "30min";
            example = "2h";
            type = types.nullOr types.str;
            description = ''
              Value for systemd's OnUnitActiveSec. Fires this long after the initial activation.
              Reference https://www.freedesktop.org/software/systemd/man/latest/systemd.time.html.
            '';
          };

          calendar = mkOption {
            default = null;
            type = types.nullOr types.str;
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
