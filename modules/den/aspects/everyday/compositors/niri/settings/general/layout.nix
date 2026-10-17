{
  niri.layout = {
    niriSettings = {
      lib,
      config,
      ...
    }: {
      layout = {
        gaps = 6;
        background-color = "transparent";
        center-focused-column = "never";
        default-column-width.proportion = 0.5;
        preset-column-widths = [
          {
            proportion = 0.333333;
          }
          {
            proportion = 0.5;
          }
          {
            proportion = 0.666667;
          }
        ];

        border = {
          width = 4;
          enable = false;
        };

        shadow = {
          enable = true;
          softness = 30;
          spread = 5;
          offset.x = 0;
          offset.y = 5;
        };
      };
    };
  };
}
