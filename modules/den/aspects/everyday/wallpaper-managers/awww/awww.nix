{den, ...}: {
  # Using parametric aspect capturing user is impossible here since schema is including it.
  # Schemas don't have access to aspect parameters.
  den.aspects.everyday.wallpaper-managers.awww = {
    description = "Wallpaper manager for Wayland, supporting dynamic wallpaper cycling.";

    includes = [
      den.aspects.everyday.wallpaper-managers.awww.script
    ];

    hm = {
      user,
      pkgs,
      lib,
      ...
    }: let
      awwwDaemon = "awww-daemon" |> lib.getExe' pkgs.awww;
      systemctl = "systemctl" |> lib.getExe' pkgs.systemdMinimal;

      cfg = user.settings.everyday.wallpaper-managers.awww.service;
    in {
      systemd.user = {
        services = {
          # Service to start the daemon
          awww-daemon = {
            Unit = {
              Description = "Start awww daemon";
              After = ["graphical-session.target"];
              Wants = ["${cfg.label}.timer"];
            };

            Service = {
              ExecStart = "${awwwDaemon}";
              ExecStartPost = "${systemctl} --user start ${cfg.label}.service";
              Restart = "on-failure";
              RestartSec = 1;
            };

            Install.WantedBy = ["graphical-session.target"];
          };
        };

        timers.${cfg.label} = {
          Unit = {
            Description = "Change wallpaper using awww";
            BindsTo = ["awww-daemon.service"];
            Wants = ["awww-daemon.service"];
          };

          Timer =
            lib.optionalAttrs (cfg.interval != null) {
              OnUnitActiveSec = cfg.interval;
            }
            // lib.optionalAttrs (cfg.calendar != null) {
              OnCalendar = cfg.calendar;
            };
        };
      };
    };
  };
}
