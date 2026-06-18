{
  den,
  lib,
  ...
}: let
  fcitx5Class = {user, ...}:
    den.batteries.forward {
      each = lib.singleton true;
      fromClass = _: "fcitx5";
      intoClass = _: "homeManager";
      intoPath = _: ["i18n" "inputMethod" "fcitx5"];
      fromAspect = _: user.aspect;
      guard = _: user.aspect ? "fcitx5";
    };
in {
  den.aspects.utility.fcitx5 = {
    includes = [fcitx5Class];

    niriSettings = {
      spawn-at-startup = [
        {
          command = ["fcitx5"];
        }
      ];
    };

    stylixHome.targets."fcitx5".enable = true;

    homeManager = {
      home.sessionVariables = {
        GTK_IM_MODULE = "fcitx5";
        QT_IM_MODULE = "fcitx5";
      };

      i18n.inputMethod = {
        enable = true;
        type = "fcitx5";

        # Suppress some warnings
        fcitx5.waylandFrontend = true;
      };
    };
  };

  den.schema.user.includes = [
    (
      {user}:
        if user.aspect ? fcitx5
        then den.aspects.utility.fcitx5
        else {}
    )
  ];
}
