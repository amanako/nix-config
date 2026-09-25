{
  den.aspects.lunar-scar.fonts = {
    nixos = {pkgs, ...}: {
      fonts.packages = with pkgs; [
        mona-sans
        noto-fonts-cjk-serif
        ipafont
        biz-ud-gothic
        inconsolata
      ];
    };

    hm = {
      user,
      lib,
      pkgs,
      ...
    }: let
      monofont = user.preferences.monofont;
      package =
        lib.attrByPath (lib.splitString "." monofont.package)
        (throw "no package named \"${monofont.package}\" in nixpkgs (preferred font)")
        pkgs;
    in {
      # Home Manager has no `fonts.packages` option, but with fontconfig enabled
      # the preferred font is picked up from the user profile, so `name` below and
      # the package here always describe the same font.
      home.packages = [package];

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

      stylix.fonts.monospace = {
        inherit package;
        inherit (monofont) name;
      };
    };
  };
}
