{
  noctalia.settings.bar.widgets = {
    hm.programs.noctalia.settings.bar.widgets = {
      background_opacity = 0.65;
      border = "hover";
      border_width = 0.5;
      capsule = true;
      capsule_border = "outline";
      capsule_fill = "outline";
      capsule_opacity = 0.4;
      capsule_padding = 7.0;
      center = ["clock" "audio_visualizer" "group:g5" "notifications"];
      color = "primary";
      contact_shadow = true;
      end = ["group:g3" "group:g1" "group:g2"];
      icon_color = "tertiary";
      layer = "top";
      margin_edge = 4;
      margin_ends = 60;
      panel_overlap = 2;
      position = "left";
      radius = 20;
      start = ["group:g4" "battery"];
      thickness = 30;

      capsule_group = [
        {
          border = "outline";
          fill = "outline";
          id = "g1";
          members = ["network" "bluetooth"];
          opacity = 0.4;
          padding = 7.0;
        }
        {
          border = "outline";
          fill = "outline";
          id = "g2";
          members = ["session" "control-center"];
          opacity = 0.4;
          padding = 7.0;
        }
        {
          border = "outline";
          fill = "outline";
          id = "g3";
          members = ["tray" "clipboard" "media"];
          opacity = 0.4;
          padding = 7.0;
        }
        {
          border = "outline";
          fill = "outline";
          id = "g4";
          members = ["launcher" "workspaces"];
          opacity = 0.4;
          padding = 7.0;
        }
        {
          border = "outline";
          fill = "outline";
          id = "g5";
          members = ["cpu" "ram" "temp"];
          opacity = 0.4;
          padding = 7.0;
        }
      ];

      left = [
        {
          id = "Network";
          displayMode = "onhover";
          iconColor = "primary";
          textColor = "none";
        }
        {
          id = "Bluetooth";
          displayMode = "graphic-clean";
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
          hideWhenZeroUnread = true;
          iconColor = "primary";
          showUnreadBadge = true;
          unreadBadgeColor = "secondary";
        }
      ];

      right = [
        {
          id = "Workspace";
          focusedColor = "primary";
          fontWeight = "medium";
          groupedBorderOpacity = 0.85;
          hideUnoccupied = true;
          iconScale = 0.8;
          labelMode = "name";
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
          colorizeSystemIcon = "tertiary";
          enableColorization = true;
          icon = "noctalia";
          useDistroLogo = false;
        }
        {
          id = "Launcher";
          enableColorization = false;
          useDistroLogo = true;
        }
      ];
    };
  };
}
