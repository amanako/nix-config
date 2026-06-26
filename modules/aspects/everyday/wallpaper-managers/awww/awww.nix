{
  den,
  __findFile,
  ...
}: {
  den.schema.user.includes = [
    (
      {user}:
        if user.awww.enable
        then den.aspects.wallpaper-managers.awww
        else {}
    )
  ];

  # Using parametric aspect capturing user is impossible here since schema is including it.
  # Schemas don't have access to aspect parameters.
  den.aspects.wallpaper-managers.awww = {
    includes = [
      <wallpaper-managers/awww/script>
    ];

    hm = {
      user,
      pkgs,
      lib,
      ...
    }: let
      awwwDaemon = "awww-daemon" |> lib.getExe' pkgs.awww;
      systemctl = "systemctl" |> lib.getExe' pkgs.systemdMinimal;

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
