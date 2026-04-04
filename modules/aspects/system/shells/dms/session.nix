{ inputs, ... }:

{
  den.aspects.system._.dms.homeManager =
    { lib, config, ... }:
    {
      options.programs.dank-material-shell.userSession = lib.mkOption {
        type = lib.types.attrs;
        example = {
          isLightMode = true;
          latitude = 40.7128;
          weatherCoordinates = "40.7128,-74.0060";
        };
        default = { };
        description = "User session to add to default session, overriding if necessary.";
      };

      # TODO: Check why default aren't overriden properly
      config.programs.dank-material-shell.session = {
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
      // config.programs.dank-material-shell.userSession;
    };
}
