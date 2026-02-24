{
	programs.qutebrowser = {
		enable = true;

		settings = {
			window = {
				hide_decoration = true;
			};

			downloads = {
				location.prompt = true;
			};

			editor = {
				command = [
					"nvim"
					"{file}"
				];
			};

			session = {
				lazy_restore = true;
			};

			tabs = {
				last_close = "blank";
			};

			statusbar = {
				widgets = [
					"keypress"
					"search_match"
					"url"
					"scroll"
					"history"
					"tabs"
					"progress"
				];
			};

			url = {
				default_page = "about:blank";
				start_pages = [
					"about:blank"
				];
			};

			content = {
				autoplay = false;
				blocking = {
					enabled = true;
					method = "both";
					adblock.lists = [
						"https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/adblock/pro.plus.txt"
						"https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/gambling-social/hosts"
					];
				};
				cache.size = 1073741824;
				cookies.accept = "no-3rdparty";

				user_stylesheets = [
					"./assets/colors.styl"
					"./assets/dark.styl"
				];
			};

			colors = {
				webpage.darkmode.enabled = false;
			};

			completion.cmd_history_max_items = 1000;
		};
	};
}
