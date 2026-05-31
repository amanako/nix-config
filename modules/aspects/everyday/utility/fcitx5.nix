{
  den.aspects.utility.fcitx5 = {
    # Required to avoid error: Conflicting managed target files: .config/fcitx5
    stylixHome.targets."fcitx5".enable = false;

    nixos.programs.localsend = {
      enable = true;
      openFirewall = true;
    };

    homeManager = {pkgs, ...}: {
      # Session variables to make availability for work with GTK and QT apps
      home.sessionVariables = {
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
  };
}
