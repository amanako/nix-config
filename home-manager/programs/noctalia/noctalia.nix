{ inputs, term, ... }:

{
  imports = [ inputs.noctalia.homeModules.default ]; 

  programs.noctalia-shell = {
    enable = true;
		plugins = {
			sources = [
				{
					enabled = true;
					name = "Official Noctalia Plugins";
					url = "https://github.com/noctalia-dev/noctalia-plugins";
				}
			];

			states = {
				pomodoro = {
					enabled = true;
					sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
				};
				battery-actions = {
					enabled = true;
					sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
				};
        clipper = {
					enabled = true;
					sourceUrl = "https://guthub.com/noctalia-dev/noctalia-plugins";
				};
				file-search = {
					enabled = true;
					sourceUrl = "https://guthub.com/noctalia-dev/noctalia-plugins";
				};
				polkit-agent = {
					enabled = true;
          sourceUrl = "https://guthub.com/noctalia-dev/noctalia-plugins";
				};
			};

			version = 2;
		};
    settings = {
      bar = {
        barType = "floating";
        position = "top";
				monitors = [
          "eDP-1"
				];
				density = "default";
        showCapsule = false;
				showOutline = false;
				contentPadding = 2;
				fontScale = 1;
				backgroundOpacity = 0.8;
				useSeparateOpacity = true;
				floating = false;
				marginVertical = 4;
				marginHorizontal = 8;
				frameThickness = 8;
				frameRadius = 12;
				outerCorners = false;
				hideOnOverview = true;
 				displayMode = "auto_hide";
				autoHideDelay = 500;
				autoShowDelay = 150;
				showOnWorkspaceSwitch = true;
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
							showPowerProfiles = true;
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
				dimmerOpacity = 0.5;
				showScreenCorners = false;
				forceBlackScreenCorners = false;
				scaleRation = 1;
        radiusRatio = 0.8;
				screenRadiusRatio = 1.1;
				animationSpeed = 0.7;
				lockOnSuspend = true;
				lockScreenAnimations = true;
				enableShadows = false;
				enableBlurBehind = true;
				allowPanelsOnScreenWithoutBar = true;
				showChangelogOnStartup = true;
				telemetryEnabled = false;
				enableLockScreenCountdown = true;
				lockScreenCountdownDuration = 10000;
				passwordChars = true;
      };

      ui = {
				fontDefault = "Mona Sans Display Light";
				fontFixed = "VictorMono NF";
        tooltipsEnabled = true;
				boxBorderEnabled = true;
				panelBackgroundOpacity = 0.8;
				panelsAttachedToBar = true;
				settingsPanelMode = "attached";
      };

      location = {
        name = "Serbia";
				weatherShowEffects = true;
        monthBeforeDay = false;
				weatherEnabled = true;
      };

      appLauncher = {
        enableClipboardHistory = true;
        enableClipPreview = true;
        position = "top_center";
        sortByMostUsed = "true";
        terminalCommand = "${term} -e";
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
        enabled = false;
      };

      notifications = {
        enabled = true;
				enableMarkdown = true;
        location = "top_right";
				backgroundOpacity = 0.8;
				respectExpireTimeout = false;

        sounds = {
	  			enabled = true;
          volume = 0.5;
				};

        enableMediaToast = false;
				enableKeyboardLayoutToast = true;
        enableBatteryToast = true;
      };

      osd = {
        enabled = true;
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
        autoSchedule = true;
        nightTemp = 3500;
        dayTemp = 6000;
      };

      desktopWidgets = {
        enabled = true;
      };

      plugins.autoUpdate = true;
    };
  };
}
