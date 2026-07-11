{
  den.aspects.optional.stylix.base-settings = {
    nixos = {
      pkgs,
      config,
      ...
    }: {
      stylix = {
        base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-soft.yaml";
        polarity = "dark";
        opacity = {
          applications = 0.87;
          desktop = 0.85;
          popups = 0.86;
          terminal = 0.85;
        };

        icons = {
          enable = true;
          package = pkgs.papirus-icon-theme;
          dark = "Papirus-Dark";
          light = "Papirus-Light";
        };

        fonts = {
          monospace = {
            package = pkgs.nerd-fonts.victor-mono;
            name = "VictorMono Nerd Font";
          };
          sansSerif = {
            package = pkgs.inter;
            name = "Inter";
          };
          # Serif fonts can be bothersome
          serif = config.stylix.fonts.sansSerif;
          emoji = {
            package = pkgs.twemoji-color-font;
            name = "Twemoji";
          };
        };
      };
    };
  };
}
