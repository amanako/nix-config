{
  den.aspects.lunar-scar.fonts = {
    nixos = {pkgs, ...}: {
      fonts.packages = with pkgs; [
        mona-sans
        noto-fonts-cjk-serif
        ipafont
        biz-ud-gothic
        inconsolata
        nerd-fonts.victor-mono
      ];
    };

    homeManager = {
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
            "VictorMono NF"
            "IPAGothic"
            "Inconsolatazi4"
          ];
        };
      };
    };
  };
}
