{
  noctalia.settings.bar.widgets = {
    homeManager.programs.noctalia-shell.settings.bar.widgets = {
      left = [
        {
          colorName = "primary";
          hideWhenIdle = true;
          id = "AudioVisualizer";
          width = 200;
        }
        {
          displayMode = "onhover";
          iconColor = "primary";
          id = "Network";
          textColor = "none";
        }
        {
          displayMode = "onhover";
          iconColor = "primary";
          id = "Bluetooth";
          textColor = "none";
        }
        {
          clockColor = "primary";
          customFont = "Mona Sans Display";
          formatHorizontal = "HH:mm ddd, MMM dd";
          formatVertical = "HH mm";
          id = "Clock";
          tooltipFormat = "HH:mm ddd, MMM dd";
          useCustomFont = true;
        }
        {
          displayMode = "graphic-clean";
          id = "Battery";
          showNoctaliaPerformance = false;
          showPowerProfiles = false;
        }
      ];
      center = [
        {
          id = "plugin:pomodoro";
        }
        {
          id = "plugin:clipper";
        }
        {
          compactMode = true;
          iconColor = "primary";
          id = "SystemMonitor";
          textColor = "primary";
        }
      ];
      right = [
        {
          characterCount = 2;
          colorizeIcons = true;
          focusedColor = "primary";
          fontWeight = "regular";
          groupedBorderOpacity = 0.7;
          hideUnoccupied = true;
          iconScale = 0.9;
          id = "Workspace";
          labelMode = "index";
          occupiedColor = "tertiary";
          pillSize = 0.6;
        }
        {
          colorizeDistroLogo = true;
          colorizeSystemIcon = "primary";
          colorizeSystemText = "none";
          customIconPath = "";
          enableColorization = true;
          icon = "noctalia";
          id = "ControlCenter";
          useDistroLogo = true;
        }
      ];
    };
  };
}
