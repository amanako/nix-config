{
  noctalia.settings.bar.widgets = {
    homeManager.programs.noctalia-shell.settings.bar.widgets = {
      left = [
        {
          id = "Network";
          displayMode = "onhover";
          iconColor = "primary";
          textColor = "none";
        }
        {
          id = "Bluetooth";
          displayMode = "onhover";
          iconColor = "primary";
          textColor = "none";
        }
        {
          id = "Clock";
          clockColor = "primary";
          formatHorizontal = "HH:mm ddd, MMM dd";
          formatVertical = "HH mm ddd";
          tooltipFormat = "HH:mm ddd, MMM dd";
        }
        {
          id = "Battery";
          displayMode = "icon-hover";
          hideIfNotDetected = true;
          showNoctaliaPerformance = true;
        }
        {
          id = "NotificationHistory";
          hideWhenZero = true;
          hideWhenZeroUnread = false;
          iconColor = "primary";
          showUnreadBadge = true;
          unreadBadgeColor = "secondary";
        }
      ];

      center = [
        {
          id = "Volume";
          displayMode = "onhover";
          iconColor = "primary";
          textColor = "none";
        }
        {
          compactMode = true;
          hideMode = "visible";
          hideWhenIdle = false;
          id = "MediaMini";
          maxWidth = 145;
          panelShowAlbumArt = true;
          scrollingMode = "hover";
          showAlbumArt = false;
          showArtistFirst = false;
          showProgressRing = true;
          showVisualizer = true;
          textColor = "primary";
          useFixedWidth = false;
          visualizerType = "wave";
        }
        {
          id = "SystemMonitor";
          compactMode = true;
          iconColor = "primary";
          showDiskUsage = true;
          showMemoryUsage = true;
          textColor = "none";
          useMonospaceFont = true;
        }
      ];

      right = [
        {
          id = "Workspace";
          labelMode = "name";
          focusedColor = "primary";
          fontWeight = "medium";
          groupedBorderOpacity = 0.85;
          hideUnoccupied = true;
          iconScale = 0.8;
          occupiedColor = "secondary";
          pillSize = 0.6;
          showApplications = true;
          showBadge = true;
          showLabelsOnlyWhenOccupied = true;
          unfocusedIconsOpacity = 0.5;
        }
        {
          id = "Tray";
          drawerEnabled = false;
          hidePassive = false;
          pinned = [];
        }
        {
          id = "ControlCenter";
          enableColorization = true;
          colorizeSystemIcon = "tertiary";
          icon = "noctalia";
          useDistroLogo = false;
        }
        {
          id = "Launcher";
          icon = "rocket";
          useDistroLogo = true;
          enableColorization = false;
        }
      ];
    };
  };
}
