{noctalia, ...}: {
  noctalia.settings.bar = {
    includes = [
      noctalia.settings.bar.widgets
    ];

    homeManager.programs.noctalia.settings.bar = {
      autoHideDelay = 500;
      autoShowDelay = 150;
      backgroundOpacity = 0.8;
      barType = "framed";
      capsuleColorKey = "tertiary";
      capsuleOpacity = 0.3;
      contentPadding = 2;
      density = "default";
      displayMode = "always_visible";
      enableExclusionZoneInset = true;
      fontScale = 1.05;
      frameRadius = 16;
      frameThickness = 5;
      hideOnOverview = true;
      marginHorizontal = 8;
      marginVertical = 4;
      middleClickAction = "settings";
      middleClickFollowMouse = false;
      monitors = ["eDP-1"];
      mouseWheelAction = "workspace";
      mouseWheelWrap = true;
      outerCorners = false;
      position = "left";
      reverseScroll = false;
      rightClickAction = "controlCenter";
      rightClickFollowMouse = true;
      showCapsule = true;
      showOnWorkspaceSwitch = true;
      showOutline = false;
      useSeparateOpacity = true;
      widgetSpacing = 4;
    };
  };
}
