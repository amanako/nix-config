{lib, ...}: {
  dms.session = {
    userSettings = {
      additionalSettings = lib.mkOption {
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
          User settings to append to default session settings, overriding if necessary.
          Passed to `homeManager.programs.dank-material-shell.session`.
        '';
      };
    };

    hm = {user, ...}: {
      programs.dank-material-shell.session =
        user.settings.dms.session.additionalSettings
        |> lib.recursiveUpdate {
          isLightMode = false;

          nightModeEnabled = true;
          nightModeTemperature = 3000;
          nightModeHighTemperature = 6000;

          nightModeAutoEnabled = true;
          nightModeAutoMode = "time";
          nightModeStartHour = 21;
          nightModeEndHour = 6;
          nightModeUseIpLocation = false;

          showThirdPartyPlugins = true;
        };
    };
  };
}
