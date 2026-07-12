{lib, ...}: {
  noctalia-shell.settings = let
    inherit
      (lib)
      mkOption
      types
      ;
  in {
    userSettings = {user, ...}: {
      overrides = mkOption {
        type = types.attrs;
        default = {};
        example = {
          currentThemeName = "gruvbox";
          showDock = true;
          controlCenterWidgets = [
            {
              id = "wifi";
              enabled = false;
              width = 100;
            }
          ];
        };
        description = "Settings to append to defaults, overriding if necessary.";
      };

      pfpName = mkOption {
        type = types.str;
        default = ".face";
        example = "my_pfp";
        description = ''
          Name to use for the avatar image without extension shown in control center and other panels.
          The path is currently immutable at `${user.repoRoot}/assets/users/${user.userName}`.
        '';
      };
    };

    hm = {
      user,
      lib,
      ...
    }: {
      programs.noctalia-shell.settings =
        user.settings.noctalia-shell.overrides
        |> lib.recursiveUpdate
        {
          general = {
            # Should be easily identifiable in user section
            avatarImage = "${user.repoRoot}/assets/users/${user.userName}/${user.settings.noctalia-shell.settings.pfpName}";
          };

          ui = {
            fontDefault = "Mona Sans Display Light";
            fontFixed = "VictorMono NF";
          };

          appLauncher = {
            terminalCommand = "${user.preferences.term} -e";
          };

          colorSchemes = {
            predefinedScheme = "Gruvbox";
          };

          wallpaper = {
            enabled = false;
            directory = "";
          };

          dock.enabled = false;

          osd = {
            enabled = true;
            location = "top_right";
            autoHideMs = 2000;
            overlayLayer = true;
            backgroundOpacity = 1;
          };

          audio = {
            volumeStep = 5;
            spectrumFrameRate = 30;
            visualizerType = "linear";
          };

          templates = {
            activeTemplates = [];
            enableUserTheming = false;
          };

          desktopWidgets = {
            enabled = false;
            monitorWidgets = [];
          };

          settingsVersion = 59;
        };
    };
  };
}
