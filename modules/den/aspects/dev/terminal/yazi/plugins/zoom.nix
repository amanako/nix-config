{
  den.aspects.dev.terminal.yazi.plugins.zoom = {
    description = "Yazi plugin to zoom in/out on hovered files in preview.";

    hm = {pkgs, ...}: {
      programs.yazi = {
        plugins.zoom.package = pkgs.yaziPlugins.zoom;

        settings.preview = {
          max_width = 1200;
          max_height = 1800;
        };

        keymap.mgr.prepend_keymap = [
          {
            on = [
              "+"
            ];
            run = "plugin zoom 1";
            desc = "Zoom in hovered file";
          }
          {
            on = [
              "-"
            ];
            run = "plugin zoom -1";
            desc = "Zoom out hovered file";
          }
        ];
      };
    };
  };
}
