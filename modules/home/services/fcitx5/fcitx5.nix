{ inputs, ... }:

{
  flake.hmModules.fcitx5 =
    { pkgs, ... }:
    {
      # Sets up necessary variables
      home.sessionVariables = {
        # This may collide with *fcitx5.waylandFrontend* option
        # so you can try enabling one at a time
        GTK_IM_MODULE = "fcitx";

        QT_IM_MODULE = "fcitx";
      };

      i18n.inputMethod = {
        enable = true;
        type = "fcitx5";

        # Supress some warnings
        fcitx5.waylandFrontend = true;

        fcitx5.addons = with pkgs; [
          # Japanese IM
          fcitx5-mozc-ut
          fcitx5-gtk
        ];
      };
    };
}
