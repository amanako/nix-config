{
  niri.windowRules.homeManager.programs.niri.settings.window-rules = [
    {
      geometry-corner-radius = {
        top-left = 12.0;
        top-right = 12.0;
        bottom-left = 12.0;
        bottom-right = 12.0;
      };
      clip-to-geometry = true;
      tiled-state = true;
      draw-border-with-background = false;
    }
    {
      # Last one is ProtonUp-Qt
      matches = [
        {
          app-id = "^(org.quickshell|nvidia-settings|thunar|net.davidotek.pupgui2)$";
        }
      ];
      open-floating = true;
      default-column-width.proportion = 0.5;
      default-window-height.proportion = 0.9;
    }
    {
      matches = [
        {
          app-id = "^(zen-twilight|mpv)$";
        }
      ];
      default-column-width.proportion = 1.0;
    }
  ];
}
