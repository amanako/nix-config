{lib, ...}: {
  dms.settings = {
    userSettings = {
      overrides = lib.mkOption {
        type = lib.types.attrs;
        default = {};
        example = {
          currentThemeName = "gruvbox";
          showDock = true;
          controlCenterWidgets = [
            {
              id = "wifi";
              enabled = false;
              width = 100;
            }
          ];
        };
        description = ''
          User settings to append to default settings, overriding if necessary.
          Passed to `homeManager.programs.dank-material-shell.settings`.
        '';
      };
    };

    hm = {
      user,
      lib,
      ...
    }: let
      inherit (user.preferences) browser;
    in {
      programs.dank-material-shell.settings =
        user.dank-material-shell.additionalSettings
        |> lib.recursiveUpdate
        {
          "24HourClock" = true;
          buttonColorMode = "primaryContainer";

          widgetBackgroundColor = "sch";
          widgetColorMode = "colorful";

          showSeconds = false;
          padHours12Hour = false;
          useFahrenheit = false;
          windSpeedUnit = "ms";

          useAutoLocation = false;

          cursorSettings = {
            size = 36;
            niri = {
              hideWhenTyping = true;
              # Visually mouse could be focusing a tile and then
              # disappearing causing inconsistency
              hideAfterInactiveMs = 0;
            };
          };

          fontWeight = 400;
          fontScale = 1;

          notepadUseMonospace = false;
          notepadFontFamily = "";
          notepadFontSize = 22;
          notepadShowLineNumbers = false;

          soundsEnabled = true;
          soundNewNotification = true;
          soundVolumeChanged = true;
          useSystemSoundTheme = true;
          soundPluggedIn = true;

          showDock = false;

          systemMonitorEnabled = true;
          systemMonitorTransparency = 0.7;
          systemMonitorWidth = 320;
          systemMonitorHeight = 480;
          systemMonitorDisplayPreferences = [
            "all"
          ];

          configVersion = 5;
        }
        // lib.optionalAttrs (browser != null) {
          # Prevent being prompted every time when selecting a browser via dms.
          browserUsageHistory = {
            ${browser} = {
              count = 1000;
              lastUsed = 1741500000000;
              name = user.preferences.browser;
            };
          };
        };
    };
  };
}
