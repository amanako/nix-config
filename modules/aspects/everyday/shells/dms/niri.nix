{inputs, ...}: {
  dms.niri = {
    description = ''
      DMS aspect providing configuration for Niri when niri is set as compositor and
      dms aspect is included.
    '';

    homeManager = {lib, ...}: {
      imports = [
        inputs.dms.homeModules.niri
      ];

      programs.dank-material-shell.niri = {
        # Don't use preset keybinds because of low coverage
        enableKeybinds = false;
        includes = {
          # We won't be using kdl files instead relying completely on nix-native config
          enable = false;
          # Change name to something different for easier recognition
          originalFileName = "dank";
        };
      };

      programs.niri.settings = {
        windows.recent-windows.highlight.corner-radius = 12;
        layout = {
          background-color = "transparent";

          border = {
            active-color = "#d0bcff";
            inactive-color = "#948f99";
            urgent-color = "#f2b8b5";
          };

          shadow.color = "#00000070";

          gaps = 6;

          border.width = 2;

          focus-ring.width = 2;

          tab-indicator = {
            active-color = "#d0bcff";
            inactive-color = "#948f99";
            urgent-color = "#f2b8b5";
          };

          insert-hint.color = "#d0bcff80";

          recent-windows.highlight = {
            active-color = "#4f378b";
            urgent-color = "#f2b8b5";
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
              ++ (lib.splitString " " args);
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
          lib.mapAttrs (_: spawnDMSCommand) binds;
      };
    };
  };
}
