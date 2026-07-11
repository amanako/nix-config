{lib, ...}: {
  noctalia.settings = let
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

      avatarFilename = mkOption {
        type = types.str;
        default = ".face";
        example = "my_pfp.jpg";
        description = ''
          Avatar filename (with extension) to be used for avatar shown in control center and other panels.
          The path of file is currently immutable at `${user.repoRoot}/assets/users/${user.userName}` and avatar should be left there.
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
