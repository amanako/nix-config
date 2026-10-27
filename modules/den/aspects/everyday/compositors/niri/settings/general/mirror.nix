{lib, ...}: {
  niri.mirror = {
    description = ''
      Provide mirroring of niri's output to an external monitor of choice.
      Implemented as window-rule + keybind for auto-spawning/killing wl-mirror process.
    '';

    userSettings = {
      sourceOutput = lib.mkOption {
        type = lib.types.str;
        default = "eDP-1";
        description = ''
          Name of the output to mirror.
          Can be looked up with niri msg outputs.
        '';
      };
      targetOutput = lib.mkOption {
        type = lib.types.str;
        example = "HDMI-A-1";
        description = ''
          Name of the output that shows the mirror.
          Mirroring is disabled while this is null.
        '';
      };
    };

    niriSettings = {
      user,
      pkgs,
      ...
    }: let
      cfg = user.settings.niri.mirror;
      wl-mirror = lib.getExe pkgs.wl-mirror;
      grep = lib.getExe pkgs.gnugrep;
      notify-send = lib.getExe' pkgs.libnotify "notify-send";
      sh = cmd: {action.spawn-sh = cmd;};
    in {
      window-rules = [
        {
          matches = [{app-id = "^at\\.yrlf\\.wl_mirror$";}];
          open-on-output = cfg.targetOutput;
          open-fullscreen = true;
          open-focused = false;
        }
      ];

      binds."Mod+Shift+M" = sh ''
        pkill -x wl-mirror || { niri msg --json outputs | ${grep} -q '"${cfg.targetOutput}"' && exec ${wl-mirror} ${cfg.sourceOutput}; } || ${notify-send} "wl-mirror" "target output ${cfg.targetOutput} not connected"
      '';
    };

    # Tell dunst to send all notifications to sourceOutput since targetOutput can hijack.
    hm = {user, ...}: {
      services.dunst.settings.global.monitor = user.settings.niri.mirror.sourceOutput;
    };
  };
}
