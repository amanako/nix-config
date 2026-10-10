{
  den.aspects.yasu.fonts = {
    nixos = {pkgs, ...}: {
      fonts.packages = with pkgs; [
        mona-sans
        noto-fonts-cjk-serif
        ipafont
        biz-ud-gothic
        inconsolata
      ];
    };

    hm = {user, ...}: let
      monofont = user.preferences.monofont;
    in {
      fonts.fontconfig = {
        enable = true;
        hinting = "slight";
        antialiasing = true;
        defaultFonts = {
          sansSerif = [
            "Biz UDPGothic"
            "IPAPGothic"
            "Noto Sans"
            "Open Sans"
            "Droid Sans"
            "NotoSansCJK"
          ];
          serif = [
            "IPAPMincho"
            "Mona Sans Display Medium"
            "Noto Serif"
            "Droid Serif"
          ];
          monospace = [
            monofont.name
            "IPAGothic"
            "Inconsolatazi4"
          ];
        };
      };
    };
  };
}
