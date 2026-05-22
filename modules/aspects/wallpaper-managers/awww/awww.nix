{
  den.aspects.wallpaper-managers._.awww = {
    # Awww keeps cached actions so we preserving it should reduce load
    persysUser.directories = [".cache/awww"];

    homeManager = {
      pkgs,
      lib,
      ...
    }: let
      awwwDaemon = lib.getExe' pkgs.awww "awww-daemon";
      systemctl = lib.getExe' pkgs.systemdMinimal "systemctl";
    in {
      systemd.user = {
        services = {
          # Service to start the daemon
          awww-daemon = {
            Unit = {
              Description = "awww Wallpaper daemon";
              After = ["graphical-session.target"];
              Wants = ["awww-random.timer"];
            };

            Service = {
              ExecStart = "${awwwDaemon}";
              ExecStartPost = "${systemctl} --user start awww-random.service";
              Restart = "on-failure";
              RestartSec = 1;
            };

            Install.WantedBy = ["graphical-session.target"];
          };
        };

        # Control unit - currently on :00 and :30 of every hour
        timers.awww-random = {
          Unit = {
            Description = "Change wallpaper every 30 minutes";
            BindsTo = ["awww-daemon.service"];
            Wants = ["awww-daemon.service"];
          };

          Timer.OnUnitActiveSec = "30min";
        };
      };
    };
  };
}
