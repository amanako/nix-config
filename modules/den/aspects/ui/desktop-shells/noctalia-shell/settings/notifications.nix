{
  noctalia-shell.settings.notifications = {
    hm.programs.noctalia-shell.settings.notifications = {
      enabled = true;
      enableMarkdown = true;
      density = "compact";
      monitors = [];
      location = "top_right";
      overlayLayer = true;
      backgroundOpacity = 0.7;
      respectExpireTimeout = false;
      lowUrgencyDuration = 3;
      normalUrgencyDuration = 8;
      criticalUrgencyDuration = 15;
      clearDismissed = true;
      saveToHistory = {
        low = true;
        normal = true;
        critical = true;
      };
      sounds = {
        enabled = true;
        volume = 0.5;
        separateSounds = false;
      };
      enableMediaToast = false;
      enableKeyboardLayoutToast = true;
      enableBatteryToast = true;
    };
  };
}
