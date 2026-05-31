# Sensible keybinds
{lib, ...}: {
  noctalia.niri = {
    homeManager.programs.niri.settings = {
      spawn-at-startup = [
        {
          command = ["noctalia-shell"];
        }
      ];

      binds = let
        spawnNoctaliaCommand = args: {
          action.spawn =
            [
              "noctalia-shell"
              "ipc"
              "call"
            ]
            ++ (lib.splitString " " args);
        };

        binds = {
          "XF86MonBrightnessDown" = "brightness decrease";
          "XF86MonBrightnessUp" = "brightness increase";
          "XF86AudioMute" = "volume muteOutput";
          "XF86AudioLowerVolume" = "volume decrease";
          "XF86AudioRaiseVolume" = "volume increase";

          "Mod+S" = "controlCenter toggle";
          "Mod+Comma" = "settings toggle";
          "Mod+Space" = "launcher toggle";

          "Mod+Shift+N" = "notifications toggleHistory";
          "Alt+Shift+C" = "calendar toggle";
          "Alt+Shift+B" = "bluetooth togglePanel";
          "Mod+Alt+V" = "volume togglePanel";
          "Mod+Shift+B" = "battery togglePanel";

          "Mod+A" = "idleInhibitor toggle";
          "Alt+Shift+L" = "sessionMenu lockAndSuspend";
          "Mod+X" = "sessionMenu toggle";

          "Ctrl+K" = "plugin:keybind-cheatsheet toggle";
          "Mod+Ctrl+C" = "plugin:clipper toggle";

          "Mod+P" = "plugin:pomodoro toggle";
          "Mod+Ctrl+P" = "plugin:pomodoro start";
          "Mod+Alt+P" = "plugin:pomodoro stop";
        };
      in
        # Interestingly, writing something like this:
        # lib.mapAttrs (_: cmd: spawnNoctaliaCommand cmd) binds
        # Produces a warning about possible eta-reduction
        lib.mapAttrs (_: spawnNoctaliaCommand) binds;
    };
  };
}
