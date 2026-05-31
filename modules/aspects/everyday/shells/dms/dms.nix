{inputs, ...}: {
  imports = [(inputs.den.namespace "dms" false)];

  flake-file.inputs.dms.url = "github:AvengeMedia/DankMaterialShell/stable";

  den.aspects.shells.dms = {
    homeManager = {
      imports = [
        inputs.dms.homeModules.dank-material-shell
        inputs.dms.homeModules.niri
      ];

      programs.dank-material-shell = {
        enable = true;
        # Systemd service provides better integration and 'dms restart' works
        systemd.enable = true;

        niri = {
          # Don't use preset keybinds because of low coverage
          enableKeybinds = false;
          includes = {
            enable = true;
            # Change name to something different for easier recognition
            originalFileName = "dank";
            # We won't be using kdl files instead relying completely on nix
            filesToInclude = [];
          };
        };

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
