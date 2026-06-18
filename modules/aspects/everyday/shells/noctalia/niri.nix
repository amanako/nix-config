# Sensible keybinds
{lib, ...}: {
  noctalia.niri = {
    niriSettings = {
      spawn-at-startup = [
        {
          command = "noctalia";
        }
      ];

      binds = let
        spawnNoctaliaCommand = args: {
          action.spawn =
            [
              "noctalia"
              "msg"
            ]
            ++ (lib.splitString " " args);
        };

        binds = {
          "XF86MonBrightnessDown" = "brightness-down";
          "XF86MonBrightnessUp" = "brightness-up";

          "XF86AudioMute" = "volume-mute";
          "XF86AudioLowerVolume" = "volume-down";
          "XF86AudioRaiseVolume" = "volume-up";

          "Mod+S" = "panel-toggle control-center";
          "Mod+Comma" = "settings-toggle";
          "Mod+Space" = "panel-toggle launcher";

          "Mod+Shift+N" = "notification-clear-history";
          "Alt+Shift+B" = "bluetooth-toggle";
          "Alt+Shift+W" = "wifi-toggle";

          "Mod+A" = "caffeine-toggle";
          "Alt+Shift+L" = "session lock-and-suspend";
          "Mod+X" = "session shutdown";
        };
      in
        lib.mapAttrs (_: spawnNoctaliaCommand) binds;
    };
  };
}
