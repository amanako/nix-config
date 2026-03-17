{ inputs, ... }:

{
  flake.modules.nixos.fonts =
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
        maple-mono.CN
        maple-mono.NF
        mona-sans
        ipafont
      ];
    };
}
