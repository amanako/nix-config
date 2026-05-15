{inputs, ...}: {
  flake-file.inputs.wallpapers = {
    url = "git+https://codeberg.org/voidptrx/wallpapers";
    flake = false;
  };

  den.aspects.appearance = {
    persysUser.directories = [".cache/awww"];

    homeManager = {
      pkgs,
      lib,
      ...
    }: let
      wallpapersPath = inputs.wallpapers.outPath;

      awwwExe = lib.getExe' pkgs.awww "awww";
      awwwDaemon = lib.getExe' pkgs.awww "awww-daemon";
      systemctl = lib.getExe' pkgs.systemdMinimal "systemctl";
      find = lib.getExe' pkgs.findutils "find";
      shuf = lib.getExe' pkgs.coreutils "shuf";

      wallpaperScript = pkgs.writeShellScriptBin "awww-random" ''
        DIR="${wallpapersPath}"
        img=$( ${find} "$DIR" -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.gif" -o -iname "*.webp" -o -iname "*.bmp" \) | ${shuf} -n 1)
        if [ -n "$img" ]; then
          ${awwwExe} img --transition-fps 144 --transition-type wave --transition-angle 225 --resize=fit "$img"
        fi
      '';
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

          # Service to rotate wallpapers
          awww-random = {
            Unit.Description = "Wallpaper rotator";

            Service = {
              ExecStart = "${lib.getExe wallpaperScript}";
              Restart = "on-failure";
              RestartSec = 2;

              Type = "oneshot";
            };
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
