{ inputs, ... }:

{
  flake.hmModules.dms-settings =
    { config, lib, ... }:
    {
      options.programs.dank-material-shell.userSettings = lib.mkOption {
        type = lib.types.attrs;
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
        default = { };
        description = "User settings to add to default settings, overriding if necessary.";
      };

      config.programs.dank-material-shell.settings = {
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
        osdAlwaysShowValue = true;
        osdPosition = 4;
        osdVolumeEnabled = true;
        osdMediaPlaybackEnabled = true;
        osdBrightnessEnabled = true;
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
        maxWorkspaceIcons = 5;
        workspaceAppIconSizeOffset = 2;
        showOccupiedWorkspacesOnly = true;
        groupWorkspaceApps = true;
        workspaceFollowFocus = false;
        dwlShowAllTags = false;
        workspaceFocusedBorderEnabled = false;
        workspaceFocusedBorderColor = "primary";
        workspaceFocusedBorderThickness = 2;
        audioWheelScrollAmount = 5;
        focusedWindowCompactMode = false;
        runningAppsCompactMode = true;
        runningAppsCurrentWorkspace = false;
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
        barMaxVisibleApps = 0;
        barMaxVisibleRunningApps = 0;

        barConfigs = [
          # Everything in bar is enabled implicitly so no need for enabled = true
          {
            enabled = true;
            autoHide = false;
            borderColor = "secondary";
            borderEnabled = true;
            borderOpacity = 0.6;
            borderThickness = 1;
            bottomGap = 2;
            id = "default";
            name = "Main Bar";
            screenPreferences = [
              "all"
            ];
            showOnLastDisplay = true;
            leftWidgets = [
              {
                id = "music";
                mediaSize = 2;
              }
              {
                id = "clock";
                clockCompactMode = true;
              }
              "weather"
            ]
            ++ lib.optionals (config.programs.dank-material-shell.plugins.nixMonitor.enable) [
              {
                id = "nixMonitor";
              }
            ];
            centerWidgets = [
              "systemTray"
              "battery"
              "controlCenterButton"
              {
                id = "cpuUsage";
                minimumWidth = true;
              }
              {
                id = "memUsage";
                minimumWidth = true;
              }
            ];
            rightWidgets = [
              "workspaceSwitcher"
              "launcherButton"
            ];
            clickThrough = false;
            fontScale = 1.2;
            spacing = 4;
            noBackground = false;
            popusGapsAuto = true;
            innerPadding = 4;
            widgetTransparency = 0.8;
            squareCorners = true;
            autoHideDelay = 250;
            openOnOverview = true;
            visible = true;
            popupGapsAuto = true;
            popupGapsManual = 4;
            maximizeWidgetIcons = false;
            transparency = 0.5;
            shadowIntensity = 20;
            position = 2;
            iconScale = 1.13;
            removeWidgetPadding = true;
            gothCornersEnabled = true;
            gothCornerRadiusOverride = true;
            gothCornerRadiusValue = 10;
            widgetOutlineEnabled = true;
            shadowColorMode = "surface";
            shadowOpacity = 65;
            maximizeDetection = true;
            widgetOutlineOpacity = 0.26;
            widgetOutlineThickness = 2;
          }
        ];
        systemMonitorEnabled = true;
        systemMonitorTransparency = 0.7;
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
      }
      // config.programs.dank-material-shell.userSettings;
    };
}
