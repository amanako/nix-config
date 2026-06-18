{
  den.aspects.core.displayManagers.lemurs = {host}: {
    # Requirement for wayland
    provides.to-users.user.extraGroups = ["seat"];

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
}
