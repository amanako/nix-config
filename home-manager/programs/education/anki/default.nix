{ config, ... }:

{
	programs.anki = {
		enable = true;
		theme = "dark";
		style = "native";
		uiScale = 1.5;
		minimalistMode = true;
		language = "en_US";
		hideTopBar = true;
		hideTopBarMode = "always";
		videoDriver = "opengl";
		profiles."${config.home.username}".sync = {
			# Add your own username and sync key text here
			usernameFile = "${config.home.homeDirectory}/nix-config/home-manager/programs/education/anki/username.txt";
			keyFile = "${config.home.homeDirectory}/nix-config/home-manager/programs/education/anki/sync-key.txt";

			autoSync = true;
			syncMedia = true;
		};
	};
}
