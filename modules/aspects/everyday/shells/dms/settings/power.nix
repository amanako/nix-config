{
  dms.settings.power = {
    homeManager.programs.dank-material-shell.settings = {
      powerActionConfirm = true;
      powerActionHoldDuration = 0.5;
      powerMenuActions = [
        "reboot"
        "logout"
        "poweroff"
        "lock"
        "suspend"
        "restart"
      ];
      powerMenuDefaultAction = "logout";

      lockBeforeSuspend = true;
      loginctlLockIntegration = true;

      osdAlwaysShowValue = true;
      osdPosition = 4;
      osdVolumeEnabled = true;
      osdMediaPlaybackEnabled = true;
      osdBrightnessEnabled = true;
    };
  };
}
