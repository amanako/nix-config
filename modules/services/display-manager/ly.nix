{ lib, ... }:

{
	services.displayManager.ly = {
	  enable = true;
		settings = {
			animation = "colormix";
			animation_frame_delay = 6;

			asterisk = "*";
			blank_box = true;
			hide_borders = false;
			load = true;

			margin_box_h = 2;
			margin_box_v = 4;
			text_in_center = true;
			full_color = true;

			hide_key_hints = true;
			hide_version_string = true;

			clear_password = true;
			default_input = "password";

			vi_mode = true;
			vi_default_mode = "insert";
	  };
	};
}
