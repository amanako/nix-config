# Sensible keybinds
{ lib, ... }:

let
  noctalia = args: {
    action.spawn = [
      "noctalia-shell"
      "ipc"
      "call"
    ]
    ++ (lib.splitString " " args);
  };
  binds = {
    "Mod+S" = "controlCenter toggle";
    "Mod+Comma" = "settings toggle";
    "Mod+Space" = "launcher toggle";

    "Mod+Shift+N" = "notifications toggleHistory";
    "Alt+Shift+C" = "calendar toggle";
    "Alt+Shift+B" = "bluetooth togglePanel";

    "XF86AudioLowerVolume" = "volume decrease";
    "XF86AudioRaiseVolume" = "volume increase";

    "Mod+Alt+V" = "volume togglePanel";
    "XF86AudioMute" = "volume muteOutput";
    "Mod+Shift+B" = "battery togglePanel";
    "XF86MonBrightnessDown" = "brightness decrease";
    "XF86MonBrightnessUp" = "brightness increase";

    "Mod+A" = "idleInhibitor toggle";
    "Alt+Shift+L" = "sessionMenu lockAndSuspend";
    "Alt+Shift+M" = "sessionMenu toggle";

    "Ctrl+K" = "plugin:keybind-cheatsheet toggle";
    "Mod+Alt+C" = "plugin:clipper toggle";
  };
in
lib.mapAttrs (name: cmd: noctalia cmd) binds
