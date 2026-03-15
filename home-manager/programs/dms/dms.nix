{ inputs, ... }:

{
  imports = [
    inputs.dms.homeModules.dank-material-shell
    inputs.dms.homeModules.niri
  ];

  programs.dank-material-shell = {
    enable = true;
    niri = {
      enableKeybinds = true;
      enableSpawn = true;
      includes.enable = false;
    };

    enableSystemMonitoring = true;
    enableVPN = true;
    enableDynamicTheming = true;
    enableAudioWavelength = true;
    enableCalendarEvents = true;
    enableClipboardPaste = true;

    settings = {
      theme = "dark";
      dynamicTheming = true;
    };

    clipboardSettings = {
      maxHistory = 50;
      maxEntrySize = 5242880;
      autoClearDays = 2;
      clearAtStartup = false;
      disabled = false;
      disableHistory = false;
      disablePersist = false;
    };
  };
}
