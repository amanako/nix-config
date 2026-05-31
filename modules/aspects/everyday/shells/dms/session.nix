{
  dms.session = {
    homeManager = {
      user,
      lib,
      ...
    }: {
      programs.dank-material-shell.session =
        lib.recursiveUpdate {
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
        }
        user.dank-material-shell.sessionSettings;
    };
  };
}
