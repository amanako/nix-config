{
  programs.noctalia-shell = {
    enable = true;
    settings = {
      bar = {
        barType = "framed";
        position = "top";
	monitors = [
          "eDP-1"
	];
	density = "default";
        showCapsule = false;
	showOutline = false;
	display_mode = "always_visible";
	backgroundOpacity = 0.8;
	useSeparateOpacity = true;
	marginVertical = 4;
	marginHorizontal = 8;
	floating = false;
	frameRadius = 12;
	frameThickness = 8;
        widgets = {
          left = [
            {
              id = "ControlCenter";
              useDistroLogo = true;
	      colorizeDistroLogo = true;
	      enableColorization = true;
	      colorizeSystemIcon = "primary";
            }
            {
              id = "Network";
	      iconColor = "primary";
            }
            {
              id = "Bluetooth";
	      iconColor = "primary";
            }
          ];
          center = [
            {
	      id = "Workspace";
              hideUnoccupied = false;
              labelMode = "index";
            }
	    {
	      id = "AudioVisualizer";
	      colorName = "primary";
	      hideWhenIdle = true;
	      width = 200;
	    }
	    {
	      id = "plugin:github-feed";
	    }
          ];
          right = [
	    {
              id = "plugin:clipper";
	    }
	    {
	      id = "SystemMonitor";
              compactMode = true;
	      iconColor = "primary";
	      showCpuTemp = true;
	      showCpuUsage = true;
	      showMemoryAsPercent = true;
	      showMemoryUsage = true;
	      textColor = "primary";
	      userMonospaceFont = true;
	    }
            {
	      id = "Battery";
	      displayMode = "graphic-clean";
              alwaysShowPercentage = false;
              warningThreshold = 20;
            }
            {
	      id = "Clock";
	      clocColor = "primary";
              formatHorizontal = "h:mm AP";
              formatVertical = "t";
	      tooltipFormat = "HH:mm ddd, MMM dd";
              useMonospacedFont = true;
              usePrimaryColor = true;
            }
          ];
        };
      };

      general = {
        avatarImage = "/home/lunar-scar/.face";
        radiusRatio = 0.8;
	dimmerOpacity = 0.5;
	showScreenCorners = true;
	forceBlackScreenCorners = true;
	screenRadisuRatio = 1.1;
	lockScreenAnimations = true;
	enableShadows = false;
	allowPanelsOnScreenWithoutBar = true;
	showChangelogOnStartup = true;
      };

      ui = {
        fontDefault = "Noto Sans";
	fontFixed = "VictorMono NF";
        tooltipEnabled = true;
	panelBackgroundOpacity = 0.8;
	panelsAttachedToBar = true;
	settingsPanelMode = "attached";
      };

      location = {
        monthBeforeDay = true;
        name = "Niš, Serbia";
	weatherEnabled = true;
	weatherShowEffects = true;
      };

      appLauncher = {
        enableClipboardHistory = true;
        enableClipPreview = true;
        position = "top_center";
        sortByMostUsed = "true";
        terminalCommand = "kitty -e";
	enableSettingsSearch = true;
	enableWindowsSearch = true;
	enableSessionSearch = true;
	overviewLayer = true;
        density = "comfortable";
      };

      controlCenter = {
        position = "top_center"; 
      };

      systemMonitor = {
        tempWarningThreshold = 60;
	tempCriticalThreshold = 80;
      };

      dock = {
        enable = false;
      };

      notifications = {
        enable = true;
        location = "top_right";
	respectExpireTimeout = true;

        sounds = {
	  enable = true;
          volume = 0.5;
	};
        enableMediaToast = false;
        enableBatteryToast = true;
	enableKeyboardLayoutToast = true;
      };

      osd = {
        enable = true;
	overlayLayer = true;
	autoHideMs = 2000;
	backgroundOpacity = 1;
      };

      audio = {
        volumeStep = 5;
	cavaFrameRate = 30;
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

      desktopWidgets = {
        enabled = true;
      };

      plugins.autoUpdate = true;
    };
  };
}
