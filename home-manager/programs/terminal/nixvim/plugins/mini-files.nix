{ config, ... }:

let 
	helpers = config.lib.nixvim;
in
{
	programs.nixvim.plugins.mini-files = {
	  enable = true;
		settings = {
      content = {
        filter = helpers.mkRaw "nil";
        highlight = helpers.mkRaw "nil";
        prefix = helpers.mkRaw "nil";
        sort = helpers.mkRaw "nil";
      };
      mappings = {
        close = "q";
        go_in = "l";
        go_in_plus = "L";
        go_out = "h";
        go_out_plus = "H";
        mark_goto = "'";
        mark_set = "m";
        reset = "<BS>";
        reveal_cwd = "@";
        show_help = "g?";
        synchronize = "=";
        trim_left = "<";
        trim_right = ">";
      };
      options = {
        permanent_delete = true;
        use_as_default_explorer = true;
      };
      windows = {
        max_number = helpers.mkRaw "math.huge";
        preview = true;
        width_focus = 50;
        width_nofocus = 15;
        width_preview = 25;
      };
		};
	};
}
