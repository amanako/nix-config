# Sensible keybinds
{ lib, ... }:

let
  dms = args: {
    action.spawn = [
      "dms"
      "ipc"
      "call"
    ]
    ++ (lib.splitString " " args);
  };

  binds = {
    "Mod+S" = "control-center toggle";
    "Mod+Comma" = "settings focusOrToggle";
    "Mod+Space" = "spotlight toggle";

    "Alt+V" = "clipboard toggle";
    # Specifically supports focusOrToggle option as well
    "Mod+M" = "processlist focusOrToggle";
    "Mod+Alt+N" = "notifications open";

    # Interpolate "" inside string
    "Mod+D" = ''dash toggle ""'';
    "Mod+W" = "welcome page 2";
    "Mod+P" = "plugins list";

    # Can pass a step additionaly, same as default now
    "XF86AudioRaiseVolume" = "audio increment 5";
    "XF86AudioLowerVolume" = "audio decrement 5";

    # TODO: Add mute function
    # Extra space at the end gets interpreted as "" which is needed for ipc call
    "XF86MonBrightnessUp" = "brightness increment 5 ";
    "XF86MonBrightnessDown" = "brightness decrement 5 ";

    "Alt+Shift+L" = "lock lock";
    "Alt+Shift+M" = "powermenu toggle";
  };
in
lib.mapAttrs (name: cmd: dms cmd) binds
