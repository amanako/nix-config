{ inputs, ... }:

{
  flake.hmModules.dms-settings = {
    programs.dank-material-shell.settings = {
      currentThemeName = "custom";
      currentThemeCategory = "registry";
      customThemeFile = "/home/lunar-scar/.config/DankMaterialShell/themes/gruvboxMaterial/theme.json";
      registryThemeVariants = {
        gruvboxMaterial = "medium";
      };
      matugenScheme = "scheme-tonal-spot";
      runUserMatugenTemplates = true;
      matugenTargetMonitor = "";
      popupTransparency = 1;
      dockTransparency = 1;
      widgetBackgroundColor = "sch";
      widgetColorMode = "colorful";
      controlCenterTileColorMode = "primaryContainer";
      buttonColorMode = "primaryContainer";
      cornerRadius = 12;
      "24HourClock" = true;
      showSeconds = false;
      padHours12Hour = false;
      useFahrenheit = false;
      windSpeedUnit = "ms";
      nightModeEnabled = false;
      animationSpeed = 3;
      customAnimationDuration = 500;
      syncComponentAnimationSpeeds = false;
      popoutAnimationSpeed = 2;
      popoutCustomAnimationDuration = 150;
      modalAnimationSpeed = 1;
      modalCustomAnimationDuration = 150;
      enableRippleEffects = true;
      wallpaperFillMode = "Fill";
      blurredWallpaperLayer = false;
      blurWallpaperOnOverview = false;
      showLauncherButton = true;
      showWorkspaceSwitcher = true;
      showFocusedWindow = true;
      showSystemTray = true;
      controlCenterWidgets = [
        {
          id = "volumeSlider";
          enabled = true;
          width = 50;
        }
        {
          id = "brightnessSlider";
          enabled = true;
          width = 50;
        }
        {
          id = "wifi";
          enabled = true;
          width = 50;
        }
        {
          id = "bluetooth";
          enabled = true;
          width = 50;
        }
        {
          id = "audioOutput";
          enabled = true;
          width = 50;
        }
        {
          id = "audioInput";
          enabled = true;
          width = 50;
        }
        {
          id = "nightMode";
          enabled = true;
          width = 50;
        }
        {
          id = "darkMode";
          enabled = true;
          width = 50;
        }
      ];
      showWorkspaceIndex = true;
      showWorkspaceName = false;
      showWorkspacePadding = false;
      workspaceScrolling = false;
      showWorkspaceApps = true;
      workspaceDragReorder = true;
      maxWorkspaceIcons = 3;
      workspaceAppIconSizeOffset = 2;
      groupWorkspaceApps = true;
      workspaceFollowFocus = false;
      showOccupiedWorkspacesOnly = false;
      reverseScrolling = false;
      dwlShowAllTags = false;
      workspaceFocusedBorderEnabled = false;
      workspaceFocusedBorderColor = "primary";
      workspaceFocusedBorderThickness = 2;
      audioWheelScrollAmount = 5;
      focusedWindowCompactMode = false;
      runningAppsCompactMode = true;
      runningAppsCurrentWorkspace = true;
      runningAppsGroupByApp = false;
      runningAppsCurrentMonitor = false;
      spotlightModalViewMode = "list";
      browserPickerViewMode = "list";
      appPickerViewMode = "list";
      sortAppsAlphabetically = false;
      appLauncherGridColumns = 4;
      spotlightCloseNiriOverview = true;
      niriOverviewOverlayEnabled = true;
      dankLauncherV2Size = "compact";
      dankLauncherV2BorderEnabled = true;
      dankLauncherV2BorderThickness = 2;
      dankLauncherV2BorderColor = "outline";
      dankLauncherV2ShowFooter = true;
      dankLauncherV2UnloadOnClose = false;
      useAutoLocation = false;
      networkPreference = "ethernet";
      iconTheme = "Papirus";
      cursorSettings = {
        theme = "System Default";
        size = 24;
        niri = {
          hideWhenTyping = true;
          hideAfterInactiveMs = 0;
        };
      };
      launcherLogoMode = "os";
      launcherLogoColorOverride = "primary";
      fontFamily = "Inter";
      monoFontFamily = "Victor Mono Nerd Font";
      fontWeight = 400;
      fontScale = 1;
      notepadUseMonospace = true;
      notepadFontFamily = "";
      notepadFontSize = 16;
      notepadShowLineNumbers = false;
      soundsEnabled = true;
      useSystemSoundTheme = false;
      soundNewNotification = true;
      soundVolumeChanged = true;
      soundPluggedIn = true;
      acMonitorTimeout = 600;
      acLockTimeout = 600;
      acSuspendTimeout = 1200;
      acSuspendBehavior = 5;
      batteryMonitorTimeout = 300;
      batteryLockTimeout = 300;
      batterySuspendTimeout = 600;
      batterySuspendBehavior = 5;
      batteryChargeLimit = 90;
      lockBeforeSuspend = true;
      loginctlLockIntegration = true;

      runDmsMatugenTemplates = true;
      matugenTemplateGtk = false;
      matugenTemplateNiri = false;
      matugenTemplateHyprland = false;
      matugenTemplateMangowc = false;
      matugenTemplateQt5ct = false;
      matugenTemplateQt6ct = false;
      matugenTemplateFirefox = false;
      matugenTemplatePywalfox = false;
      matugenTemplateZenBrowser = false;
      matugenTemplateVesktop = false;
      matugenTemplateEquibop = false;
      matugenTemplateGhostty = false;
      matugenTemplateKitty = false;
      matugenTemplateFoot = false;
      matugenTemplateAlacritty = false;
      matugenTemplateNeovim = false;
      matugenTemplateWezterm = false;
      matugenTemplateDgop = true;
      matugenTemplateKcolorscheme = false;
      matugenTemplateVscode = false;
      matugenTemplateEmacs = false;
      matugenTemplateZed = false;

      showDock = false;
      notificationOverlayEnabled = true;
      notificationPopupShadowEnabled = true;
      notificationPopupPrivacyMode = false;
      modalDarkenBackground = true;
      maxFprintTries = 15;
      hideBrightnessSlider = false;
      notificationTimeoutLow = 5000;
      notificationTimeoutNormal = 5000;
      notificationTimeoutCritical = 0;
      notificationCompactMode = true;
      icationAnimationSpeed = 2;
      notificationCustomAnimationDuration = 400;
      powerActionConfirm = true;
      powerActionHoldDuration = 0.2;
      powerMenuActions = [
        "reboot"
        "logout"
        "poweroff"
        "lock"
        "suspend"
        "restart"
      ];
      powerMenuDefaultAction = "logout";
      barConfigs = [
        {
          id = "default";
          name = "Main Bar";
          enabled = true;
          screenPreferences = [
            "all"
          ];
          showOnLastDisplay = true;
          leftWidgets = [
            "launcherButton"
            "workspaceSwitcher"
            "focusedWindow"
            {
              id = "nixMonitor";
              enabled = true;
            }
          ];
          centerWidgets = [
            "music"
            "clock"
            "weather"
          ];
          rightWidgets = [
            {
              id = "systemTray";
              enabled = true;
            }
            {
              id = "battery";
              enabled = true;
            }
            {
              id = "cpuUsage";
              enabled = true;
            }
            {
              id = "memUsage";
              enabled = true;
            }
            {
              id = "controlCenterButton";
              enabled = true;
            }
          ];
          spacing = 4;
          innerPadding = 4;
          bottomGap = 0;
          transparency = 1;
          widgetTransparency = 1;
          squareCorners = false;
          noBackground = false;
          borderEnabled = false;
          borderColor = "surfaceText";
          borderOpacity = 1;
          borderThickness = 1;
          fontScale = 1;
          autoHide = false;
          autoHideDelay = 250;
          openOnOverview = true;
          visible = true;
          popupGapsAuto = true;
          popupGapsManual = 4;
          clickThrough = false;
          maximizeWidgetIcons = false;
        }
      ];
      systemMonitorEnabled = true;
      systemMonitorWidth = 320;
      systemMonitorHeight = 480;
      systemMonitorDisplayPreferences = [
        "all"
      ];
      systemMonitorVariants = [ ];
      desktopWidgetPositions = { };
      desktopWidgetGridSettings = { };
      desktopWidgetInstances = [ ];
      desktopWidgetGroups = [ ];
      clipboardEnterToPaste = false;
      configVersion = 5;
    };
  };
}
