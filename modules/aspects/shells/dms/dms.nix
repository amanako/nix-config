{ inputs, ... }:

{
  flake-file.inputs = {
    dms.url = "github:AvengeMedia/DankMaterialShell/stable";
  };

  den.aspects.shells._.dms.homeManager =
    { lib, config, ... }:
    let
      isAutoSpawned = config.programs.niri.autoSpawnShell == "dms";
      # This path needs to be updated each time folders are moved around or renamed
      # This remains pure but don't forget to change accordingly
      currentDir = "${config.home.homeDirectory}/nix-config/modules/aspects/shells/shells/dms";
    in
    {
      imports = [
        inputs.dms.homeModules.dank-material-shell
        inputs.dms.homeModules.niri
      ];

      config = lib.mkIf isAutoSpawned {
        # Generate symlink to .config/niri/dms and .config/DankMaterialShell/settings.json for automatic reload with configuration
        xdg.configFile."niri/dms".source = config.lib.file.mkOutOfStoreSymlink "${currentDir}/dmsNiriFiles";

        programs.dank-material-shell = {
          enable = true;
          # Systemd service provides better integration and 'dms restart' works
          systemd.enable = true;

          niri = {
            # Don't use preset keybinds because of low coverage
            enableKeybinds = false;
            includes = {
              enable = true;

              # Allow dms niri settings to take precedence over niri-flake settings
              override = true;
              # Change name to something different for easier recognition
              originalFileName = "dank";
              filesToInclude = [
                "alttab"
                "binds"
                "colors"
                "cursor"
                "layout"
                "outputs"
                "windowrules"
                "wpblur"
              ];
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
