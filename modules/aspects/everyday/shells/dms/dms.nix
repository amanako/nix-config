{inputs, ...}: {
  imports = [(inputs.den.namespace "dms" false)];

  flake-file.inputs.dms.url = "github:AvengeMedia/DankMaterialShell/stable";

  den.aspects.shells.dms = {
    homeManager = {
      imports = [
        inputs.dms.homeModules.dank-material-shell
      ];

      programs.dank-material-shell = {
        enable = true;
        # Systemd service provides better integration and 'dms restart' works
        systemd.enable = true;

        enableSystemMonitoring = true;
        enableVPN = false;
        enableDynamicTheming = true;
        enableAudioWavelength = true;
        enableCalendarEvents = true;
        enableClipboardPaste = true;

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
    };
  };
}
