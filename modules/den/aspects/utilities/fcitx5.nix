{
  den.aspects.utilities.fcitx5 = {
    description = "Input method framework with Wayland support.";

    niriSettings = {
      spawn-at-startup = [
        {
          command = ["fcitx5"];
        }
      ];
    };

    hm = {
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
