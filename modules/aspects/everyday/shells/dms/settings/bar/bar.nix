{dms, ...}: {
  dms.bar = {
    includes = [
      dms.bar.widgets
    ];

    homeManager = {
      programs.dank-material-shell.settings = {
        # Unlimited
        barMaxVisibleApps = 0;
        barMaxVisibleRunningApps = 0;

        barConfigs = [
          {
            id = "default";
            name = "Main Bar";

            enabled = true;
            autoHide = false;
            visible = true;
            openOnOverview = true;
            clickThrough = false;
            bottomGap = 2;
            screenPreferences = [
              "all"
            ];

            borderColor = "secondary";
            borderEnabled = true;
            borderOpacity = 0.6;
            borderThickness = 1;

            showOnLastDisplay = true;
            fontScale = 1.2;
            spacing = 4;
            noBackground = false;
            popusGapsAuto = true;
            innerPadding = 4;
            squareCorners = true;
            autoHideDelay = 250;
            popupGapsAuto = true;
            popupGapsManual = 4;
            maximizeWidgetIcons = false;
            transparency = 0.5;
            shadowIntensity = 20;
            position = 2;
            iconScale = 1.13;
            removeWidgetPadding = true;

            widgetTransparency = 0.8;
            widgetOutlineEnabled = true;
            widgetOutlineOpacity = 0.26;
            widgetOutlineThickness = 2;

            shadowColorMode = "surface";
            shadowOpacity = 65;
            maximizeDetection = true;

            gothCornersEnabled = true;
            gothCornerRadiusOverride = true;
            gothCornerRadiusValue = 10;
          }
        ];
      };
    };
  };
}
