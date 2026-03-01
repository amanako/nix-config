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
		profiles."User 1".sync = {
			usernameFile = "/home/lunar-scar/nix-config/home-manager/programs/education/anki/username.txt";
			keyFile = "/home/lunar-scar/nix-config/home-manager/programs/education/anki/sync-key.txt";
			autoSync = true;
			syncMedia = true;
		};
	};
}
