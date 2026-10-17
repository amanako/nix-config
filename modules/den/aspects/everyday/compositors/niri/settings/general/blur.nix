{
  niri.blur = {
    niriSettings = {
      window-rules = [
        {
          opacity = 0.87;
          background-effect = {
            blur = true;
          };
        }
      ];

      layer-rules = [
        {
          excludes = [
            {
              namespace = "^main$";
            }
          ];
          opacity = 0.87;
          background-effect = {
            blur = true;
          };
        }
        {
          matches = [
            {
              namespace = "^main$";
            }
          ];
          geometry-corner-radius = {
            top-left = 12.0;
            top-right = 12.0;
            bottom-left = 12.0;
            bottom-right = 12.0;
          };
          opacity = 0.87;
          background-effect = {
            blur = true;
          };
        }
      ];

      blur = {
        enable = true;
        passes = 5;
        offset = 2.0;
        saturation = 3;
      };
    };
  };
}
