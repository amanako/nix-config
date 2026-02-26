{
  home = {
    username = "lunar-scar";
    homeDirectory = "/home/lunar-scar";
  };
 
  imports = [
    ./programs
		./services
  ];

	nixpkgs.config.allowUnfree = true;
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  home.stateVersion = "25.11";
}
