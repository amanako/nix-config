{
  noctalia.settings.notification = {
    hm.programs.noctalia.settings.notification = {
      background_opacity = 0.85;
      layer = "overlay";
      offset_y = 10;
    };
  };

  noctalia.settings.notifications = {
    hm.programs.noctalia.settings.notifications = {
      backgroundOpacity = 0.7;
      clearDismissed = true;
      criticalUrgencyDuration = 15;
      density = "compact";
      enableBatteryToast = true;
      enableKeyboardLayoutToast = true;
      enableMarkdown = true;
      enableMediaToast = false;
      enabled = true;
      location = "top_right";
      lowUrgencyDuration = 3;
      monitors = [];
      normalUrgencyDuration = 8;
      overlayLayer = true;
      respectExpireTimeout = false;

      saveToHistory = {
        critical = true;
        low = true;
        normal = true;
      };

      sounds = {
        enabled = true;
        separateSounds = false;
        volume = 0.5;
      };
    };
  };
}
