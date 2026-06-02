{
  den,
  lib,
  ...
}: let
  fcitx5Class = {user, ...}:
    den.batteries.forward {
      each = lib.singleton true;
      fromClass = _: "fcitx5";
      intoClass = _:
        if (lib.elem "homeManager" user.classes)
        then "homeManager"
        else "nixos";
      intoPath = _: ["i18n" "inputMethod" "fcitx5"];
    };
in {
  den.aspects.fcitx5 = {user, ...}: let
    commonConfig = {
      i18n.inputMethod = {
        enable = true;
        type = "fcitx5";

        # Suppress some warnings
        fcitx5.waylandFrontend = true;
      };
    };
    variables = {
      GTK_IM_MODULE = "fcitx5";
      QT_IM_MODULE = "fcitx5";
    };
  in {
    includes = [fcitx5Class];

    niriSpawnAtStartup = {
      command = ["fcitx5"];
    };

    # Required to avoid error: Conflicting managed target files: .config/fcitx5
    stylixHome.targets."fcitx5".enable = false;

    nixos = let
      isInHmClass = lib.elem "homeManager" user.classes;
    in
      lib.optionalAttrs (!isInHmClass) commonConfig
      // {
        environment.sessionVariables = variables;
      };

    homeManager =
      commonConfig
      // {
        # Session variables to make availability for work with GTK and QT apps
        home.sessionVariables = variables;
      };
  };

  den.schema.user.includes = [den.aspects.fcitx5];
}
