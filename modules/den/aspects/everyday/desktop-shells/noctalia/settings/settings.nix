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
          theme.mode = "dark";
          bar.main.position = "left";
          showDock = true;
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
          shell = {
            avatar_path = "${user.repoRoot}/assets/users/${user.userName}/${user.settings.noctalia.settings.avatarFilename}";
            font_family = "Mona Sans Display Light";
            time_format = "{:%H:%M}";
          };
        };
    };
  };
}
