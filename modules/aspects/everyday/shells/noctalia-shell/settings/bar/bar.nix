{noctalia-shell, ...}: {
  noctalia-shell.settings.bar = {
    includes = [
      noctalia-shell.settings.bar.widgets
    ];

    homeManager.programs.noctalia-shell.settings.bar = {
      barType = "framed";
      position = "left";
      monitors = [
        "eDP-1"
      ];
      density = "default";
      showOutline = false;
      showCapsule = true;

      capsuleOpacity = 0.3;
      capsuleColorKey = "tertiary";

      widgetSpacing = 4;
      contentPadding = 2;
      fontScale = 1.05;
      enableExclusionZoneInset = true;
      backgroundOpacity = 0.8;
      useSeparateOpacity = true;
      marginVertical = 4;
      marginHorizontal = 8;
      frameThickness = 5;
      frameRadius = 16;
      outerCorners = false;
      hideOnOverview = true;
      displayMode = "always_visible";
      autoHideDelay = 500;
      autoShowDelay = 150;
      showOnWorkspaceSwitch = true;
      mouseWheelAction = "workspace";
      reverseScroll = false;
      mouseWheelWrap = true;

      middleClickAction = "settings";
      middleClickFollowMouse = false;

      rightClickAction = "controlCenter";
      rightClickFollowMouse = true;
    };
  };
}
