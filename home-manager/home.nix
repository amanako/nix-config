{ username, ... }:

{
  home = {
    username = username;
    homeDirectory = "/home/${username}";
  };
 
  imports = [
    ./programs
		./env/session-variables.nix
  ];

	nixpkgs.config.allowUnfree = true;
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  home.stateVersion = "25.11";
}
