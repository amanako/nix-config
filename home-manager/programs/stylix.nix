{ pkgs, ... }:

{
  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
    polarity = "dark";

    icons = {
      enable = true;
      package = pkgs.papirus-icon-theme;

      dark = "Papirus-Dark";
      light = "Papirus-Light";
    };

    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.victor-mono;
	name = "Victor Mono NF";
      };
    };

    targets = {
      noctalia-shell.enable = false;
      starship.enable = false;
      nixvim.enable = false;
    };
  };
}
