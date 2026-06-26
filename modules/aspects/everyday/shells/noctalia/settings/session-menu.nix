{
  noctalia.settings.sessionMenu = {
    hm.programs.noctalia.settings.sessionMenu = {
      countdownDuration = 10000;
      enableCountdown = true;
      largeButtonsLayout = "grid";
      largeButtonsStyle = true;
      position = "center";
      showHeader = true;
      showKeybinds = true;

      powerOptions = [
        {
          action = "lock";
          command = "";
          countdownEnabled = true;
          enabled = true;
          keybind = "1";
        }
        {
          action = "suspend";
          command = "";
          countdownEnabled = true;
          enabled = true;
          keybind = "2";
        }
        {
          action = "logout";
          command = "";
          countdownEnabled = true;
          enabled = true;
          keybind = "3";
        }
        {
          action = "shutdown";
          command = "";
          countdownEnabled = true;
          enabled = true;
          keybind = "4";
        }
        {
          action = "reboot";
          command = "";
          countdownEnabled = true;
          enabled = true;
          keybind = "5";
        }
        {
          action = "rebootToUefi";
          command = "";
          countdownEnabled = true;
          enabled = true;
          keybind = "6";
        }
      ];
    };
  };
}
