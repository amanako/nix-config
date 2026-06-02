{
  noctalia.settings = {
    homeManager = {
      user,
      lib,
      ...
    }: {
      programs.noctalia-shell.settings =
        lib.recursiveUpdate
        {
          general = {
            # Should be easily identifyable in user section
            avatarImage = "${user.repoRoot}/assets/users/${user.userName}/${user.noctalia-shell.pfpName}";
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
        }
        user.noctalia-shell.additionalSettings;
    };
  };
}
