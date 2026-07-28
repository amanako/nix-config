{lib, ...}: {
  den.aspects.core.display-managers.ly = {
    description = "TUI display manager with a clean, console-based interface.";

    hostSettings = {
      batteryID = lib.mkOption {
        type = lib.types.str;
        default = "";
        example = "BAT0";
        description = ''
          Option named native-path assigned to batteries of pcs and laptops.
          Can be obtained by running `upower -b | grep -E 'vendor|model|native-path'`
          Currently used by ly display manager to display battery percentage.
        '';
      };
    };

    nixos = {host, ...}: {
      services.displayManager.ly = {
        enable = true;
        settings = {
          animation = "matrix";
          animation_frame_delay = 5;

          asterisk = "*";
          blank_box = true;
          hide_borders = false;
          load = true;

          margin_box_h = 2;
          margin_box_v = 4;
          text_in_center = true;
          full_color = true;

          clear_password = true;
          default_input = "password";

          vi_mode = true;
          vi_default_mode = "insert";

          battery_id = host.settings.core.display-managers.ly.batteryID;
        };
      };
    };
  };
}
