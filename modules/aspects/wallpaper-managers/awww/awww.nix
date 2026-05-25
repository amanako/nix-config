{
  den.aspects.wallpaper-managers._.awww = {
    # Awww keeps cached actions so preserving directory should reduce load
    persysUser.directories = [".cache/awww"];

    homeManager = {
      user,
      pkgs,
      lib,
      ...
    }: let
      awwwDaemon = lib.getExe' pkgs.awww "awww-daemon";
      systemctl = lib.getExe' pkgs.systemdMinimal "systemctl";

      service = user.awww.service.label;
    in {
      systemd.user = {
        services = {
          # Service to start the daemon
          awww-daemon = {
            Unit = {
              Description = "Start awww daemon";
              After = ["graphical-session.target"];
              Wants = ["${service}.timer"];
            };

            Service = {
              ExecStart = "${awwwDaemon}";
              ExecStartPost = "${systemctl} --user start ${service}.service";
              Restart = "on-failure";
              RestartSec = 1;
            };

            Install.WantedBy = ["graphical-session.target"];
          };
        };

        timers.${service} = {
          Unit = {
            Description = "Change wallpaper using awww";
            BindsTo = ["awww-daemon.service"];
            Wants = ["awww-daemon.service"];
          };

          Timer = let
            cfg = user.awww.service;
          in
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
