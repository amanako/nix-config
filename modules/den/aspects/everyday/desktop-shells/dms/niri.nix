{den, ...}: {
  dms.niri = {
    includes = [
      den.aspects.everyday.launchers.conflict-manager
    ];

    niriSettings = {
      config,
      lib,
      ...
    }: let
      colors =
        lib.attrByPath ["lib" "stylix" "colors" "withHashtag"] {
          base03 = "#948f99";
          base08 = "#f2b8b5";
          base0D = "#d0bcff";
          base0E = "#4f378b";
        }
        config;
    in {
      windows.recent-windows.highlight.corner-radius = 12;
      layout = {
        background-color = "transparent";

        border = {
          active-color = colors.base0D;
          inactive-color = colors.base03;
          urgent-color = colors.base08;
        };

        shadow.color = "#00000070";

        gaps = 6;

        border.width = 2;

        focus-ring.width = 2;

        tab-indicator = {
          active-color = colors.base0D;
          inactive-color = colors.base03;
          urgent-color = colors.base08;
        };

        insert-hint.color = "${colors.base0D}80";

        recent-windows.highlight = {
          active-color = colors.base0E;
          urgent-color = colors.base08;
        };
      };

      cursor = {
        xcursor-theme = "capitaine-cursors-white";
        xcursor-size = 36;
        hide-when-typing = true;
        hide-after-inactive-ms = 4004;
      };

      window-rule = [
        {
          geometry-corner-radius = 12;
          clip-to-geometry = true;
          tiled-state = true;
          draw-border-with-background = false;
        }
        {
          match-app-id = "^org.gnome$";
          draw-border-with-background = false;
          geometry-corner-radius = 12;
          clip-to-geometry = true;
        }
        {
          match-app-id = "^org.quickshell$";
          open-floating = true;
        }
        {
          match-is-active = false;
          opacity = 0.7;
        }
      ];
      binds = let
        spawnDMSCommand = args: {
          action.spawn =
            [
              "dms"
              "ipc"
              "call"
            ]
            ++ (args |> lib.splitString " ");
        };
        binds = {
          "Super+Alt+L" = "lock lock";
          "Super+X" = "powermenu toggle";
          "Alt+V" = "clipboard toggle";
          "Alt+P" = "color-picker toggle";
          "Mod+Alt+N" = "notifications open";
          "Mod+Comma" = "settings focusOrToggle";
          "Mod+D" = "dash toggle";
          "Mod+M" = "processlist focusOrToggle";
          "Mod+P" = "notepad toggle";
          "Mod+S" = "control-center toggle";
          "Mod+A" = "inhibit toggle";
          "Mod+Space" = "spotlight toggle";
          "Mod+W" = "welcome page 2";
          "XF86AudioMute" = "audio mute";
          "XF86AudioMicMute" = "audio micmute";
          "XF86AudioLowerVolume" = "audio decrement 5";
          "XF86AudioRaiseVolume" = "audio increment 5";
          "XF86MonBrightnessDown" = "brightness decrement 5";
          "XF86MonBrightnessUp" = "brightness increment 5";
        };
      in
        binds
        |> lib.mapAttrs (_: spawnDMSCommand);
    };
  };
}
