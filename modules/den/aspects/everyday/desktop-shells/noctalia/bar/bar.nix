{noctalia, ...}: {
  noctalia.bar = {
    includes = [
      noctalia.bar.widgets
    ];

    hm.programs.noctalia.settings.bar = {
      order = ["main"];

      main = {
        position = "left";
        thickness = 30;
        background_opacity = 0.8;
        radius = 20;
        margin_ends = 60;
        margin_edge = 4;
        padding = 7;
        widget_spacing = 4;
        scale = 1.0;
        font_scale = 1.05;
        font_weight = 500;
        shadow = true;
        contact_shadow = true;
        border = "outline";
        border_width = 1.0;
        auto_hide = false;
        smart_auto_hide = false;
        reserve_space = true;
        hover_highlight = true;
        capsule = true;
        capsule_opacity = 0.4;
        capsule_fill = "outline";

        start = ["launcher" "workspaces" "battery"];
        center = ["clock" "cpu" "ram" "temp" "notifications"];
        end = ["tray" "clipboard" "media" "network" "bluetooth" "session" "control-center"];
      };
    };
  };
}
