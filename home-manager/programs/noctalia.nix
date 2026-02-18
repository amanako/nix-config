{
  programs.noctalia-shell = {
    enable = true;
    settings = {
      bar = {
        barType = "simple";
        position = "top";
	monitors = [
          "eDP-1"
	];
	density = "default";
        showCapsule = false;
	showOutline = false;
        widgets = {
          left = [
            {
              id = "ControlCenter";
              useDistroLogo = true;
            }
            {
              id = "Network";
            }
            {
              id = "Bluetooth";
            }
          ];
          center = [
            {
              hideUnoccupied = false;
              id = "Workspace";
              labelMode = "none";
            }
          ];
          right = [
            {
              alwaysShowPercentage = false;
              id = "Battery";
              warningThreshold = 20;
            }
            {
              formatHorizontal = "HH:mm";
              formatVertical = "HH mm";
              id = "Clock";
              useMonospacedFont = true;
              usePrimaryColor = true;
            }
          ];
        };
      };

      general = {
        #avatarImage = "/home/drfoobar/.face";
        radiusRatio = 0.2;
      };
      location = {
        monthBeforeDay = true;
        name = "Niš, Serbia";
      };

      ui = {
        fontDefault = "Noto Sans";
	fontFixed = "VictorMono NF";
        tooltipEnabled = true;
      };

      appLauncher = {
        enableClipboardHistory = true;
        enableClipPreview = true;
        position = "top_center";
        sortByMostUsed = "true";
        terminalCommand = "kitty -e";
        density = "comfortable";
      };

      controlCenter = {
        position = "close_to_bar_button";
      };

      notifications = {
        enable = true;
        location = "top_right";

        sounds.enable = true;
        enableMediaToast = true;
        enableBatteryToast = true;
      };

      colorSchemes = {
        predefinedScheme = "Gruvbox";
        darkMode = true;
      };

      nightLight = {
        enabled = true;
        nightTemp = 3500;
        dayTemp = 6000;
        autoSchedule = true;
      };

      plugins.autoUpdate = true;
    };
  };
}
