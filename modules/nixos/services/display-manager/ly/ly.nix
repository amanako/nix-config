{ inputs, ... }:

{
  # Ly is great because it doesn't require systemd to function
  # Configuration file for reference can be found here:
  # https://codeberg.org/fairyglade/ly/src/branch/master/res/config.ini#
  flake.modules.nixos.ly = {
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
        battery_id = "BAT1";
      };
    };
  };
}
