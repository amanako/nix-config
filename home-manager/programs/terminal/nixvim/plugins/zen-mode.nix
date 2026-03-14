{
	plugins.zen-mode = {
		enable = true;
		settings = {
			window = {
				backdrop = 0.95;
				height = 1;
				width = 120;

				options = {
					signcolumn = "no";
					number = false;
				};
			};
			plugins = {
				gitsigns.enabled = false;
				kitty.enabled = true;

				options = {
					enabled = true;
					ruler = false;
					showcmd = false;
				};
			};
		};
	};
}
