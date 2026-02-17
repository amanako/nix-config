{ pkgs, ... }:

{
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    liberation_ttf
    dina-font
    proggyfonts
    nerd-fonts.victor-mono
    biz-ud-gothic
  ];
}
