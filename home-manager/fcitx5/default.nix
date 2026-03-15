{ pkgs, ... }:

{
	i18n.inputMethod= {
		enable = true;
		type = "fcitx5";

		fcitx5.waylandFrontend = true;
		fcitx5.addons = with pkgs; [
			fcitx5-mozc-ut
			fcitx5-gtk
		];

		fcitx5.settings = import ./settings.nix;
	};
}
