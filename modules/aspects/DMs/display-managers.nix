{
  den.aspects.displayManagers = {
    provides.lemurs = {
      # TODO: Implement conditional for adding user to "seat" group
      # Required for Wayland and would work correctly
      nixos.services.displayManager.lemurs = {
        enable = true;
        settings = {
          tty = 1;
          do_log = true;
          focus_behaviour = "password";

          background = {
            show_background = true;
            style = {
              color = "dark gray";
              show_border = true;
              border_color = "orange";
            };
          };

          username_field.remember = true;
          password_field.content_replacement_character = "*";
        };
      };
    };

    provides.ly = {
      nixos.services.displayManager.ly = {
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
        };
      };
    };
  };
}
