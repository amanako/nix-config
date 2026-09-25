{
  den.aspects.extra.stylix.base-settings = {
    description = "Base stylix theming defaults: theme, fonts, and icon pack.";

    # Fixes E79 spam error on startup due to broken variable expanding.
    # Reference commit: fix(nixvim): remove constant E79 error on startup + QOL.
    stylixHMSettings.targets."kde".enable = false;

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
          # Monospace is a per user preference (`preferences.monofont`) and is set in
          # the user font aspect, since it is not a system wide choice.
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
