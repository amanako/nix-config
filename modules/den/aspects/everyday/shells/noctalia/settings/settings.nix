{lib, ...}: {
  noctalia.settings = let
    inherit
      (lib)
      mkOption
      types
      ;
  in {
    userSettings = {
      overrides = mkOption {
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
        default = {};
        type = types.attrs;
        description = "Settings to append to defaults, overriding if necessary.";
      };

      avatarFilename = mkOption {
        example = "my_pfp.jpg";
        default = ".face";
        type = types.str;
        description = ''
          Avatar filename (with extension) to be used for avatar shown in control center and other panels.
          The path of file is currently immutable at `$repoRoot/assets/users/$username` and avatar should be left there.
        '';
      };
    };

    hm = {
      user,
      lib,
      ...
    }: {
      programs.noctalia.settings =
        user.settings.noctalia.settings.overrides
        |> lib.recursiveUpdate
        {
          settingsVersion = 60;

          shell.avatar_path = "${user.repoRoot}/assets/users/${user.userName}/${user.settings.noctalia.settings.avatarFilename}";
          appLauncher.terminalCommand = "${user.preferences.term} -e";

          ui = {
            fontDefault = "Mona Sans Display Light";
            fontFixed = "VictorMono NF";
          };
        };
    };
  };
}
