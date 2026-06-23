{
  dms.settings = {
    homeManager = {
      user,
      lib,
      ...
    }: {
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

          # Prevent being prompted every time when selecting a browser via dms.
          browserUsageHistory = let
            inherit (user.preferences) browser;
          in {
            ${browser} = {
              count = 1000;
              lastUsed = 1741500000000;
              name = browser;
            };
          };

          configVersion = 5;
        };
    };
  };
}
