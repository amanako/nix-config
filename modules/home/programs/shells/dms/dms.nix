{ inputs, ... }:

{
  flake.hmModules.dms =
    { lib, config, ... }:
    let
      isAutoSpawned = config.programs.niri.autoSpawnShell == "dms";
    in
    {
      imports = [
        inputs.dms.homeModules.dank-material-shell
        inputs.dms.homeModules.niri
        inputs.self.hmModules.dms-plugins
        inputs.self.hmModules.dms-settings
      ];

      config = lib.mkIf isAutoSpawned {

        # Inject binds into niri if dms will be spawned
        programs.niri.settings.binds = import ./_binds.nix { inherit lib; };

        # Generate symlink to .config/niri/dms for automatic reload with configuration
        home.file.".config/niri/dms" = {
          source = ./dms;
          recursive = true;
        };

        programs.dank-material-shell = {
          enable = true;
          # Systemd service provides better integration and restarting works
          systemd.enable = true;

          niri = {
            # Don't use preset keybinds because of low coverage
            enableKeybinds = false;
            includes = {
              enable = true;

              # Allow dms to override config.kdl for functionality only if it will be spawned
              override = true;
              # Change name to something different for easier recognition
              originalFileName = "dank";
              filesToInclude = [
                "colors"
                "layout"
                #"cursor"
              ];
            };
          };

          enableSystemMonitoring = true;
          enableVPN = true;
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
