{ config, ... }:

{
  home.sessionVariables = {
    EDITOR = "nvim";
    TERM = "kitty";
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    NH_FLAKE = if config.enableNH then "${config.home.homeDirectory}/nix-config/" else "";
  };
}
