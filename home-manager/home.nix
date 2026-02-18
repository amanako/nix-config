{ inputs, ... }:

{
  home = {
    username = "lunar-scar";
    homeDirectory = "/home/lunar-scar";
  };
 
  nixpkgs.config.allowUnfree = true;

  imports = [
    inputs.niri.homeModules.niri
    inputs.noctalia.homeModules.default
    inputs.nixvim.homeModules.nixvim
    inputs.stylix.homeModules.stylix
    ./programs
  ];

  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    settings = {
      user.name = "shizumu-iruka";
      user.email = "github@kairi6.anonaddy.com";
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  home.stateVersion = "25.11";
}
