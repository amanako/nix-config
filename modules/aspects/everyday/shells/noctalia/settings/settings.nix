{
  noctalia.settings = {
    hm = {
      user,
      lib,
      ...
    }: {
      programs.noctalia.settings =
        user.noctalia.additionalSettings
        |> lib.recursiveUpdate
        {
          settingsVersion = 60;

          shell = {
            avatar_path = "${user.repoRoot}/assets/users/${user.userName}/${user.noctalia.avatarFilename}";
          };

          appLauncher = {
            terminalCommand = "${user.preferences.term} -e";
          };

          ui = {
            fontDefault = "Mona Sans Display Light";
            fontFixed = "VictorMono NF";
          };
        };
    };
  };
}
