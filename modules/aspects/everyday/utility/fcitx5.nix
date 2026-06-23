{
  den.aspects.utility.fcitx5 = {
    niriSettings = {
      spawn-at-startup = [
        {
          command = ["fcitx5"];
        }
      ];
    };

    stylixHMSettings.targets."fcitx5".enable = true;

    homeManager = {
      fcitx5Settings,
      lib,
      ...
    }: {
      home.sessionVariables = {
        GTK_IM_MODULE = "fcitx5";
        QT_IM_MODULE = "fcitx5";
      };

      i18n.inputMethod = {
        enable = true;
        type = "fcitx5";

        # Suppress some warnings
        fcitx5.waylandFrontend = true;

        fcitx5.settings =
          fcitx5Settings
          |> lib.foldl' lib.recursiveUpdate {};
      };
    };
  };
}
