{ inputs, lib, pkgs, ... }:

{
  imports = [

  ];

  home = {
    username = "lunar-scar";
    homeDirectory = "/home/lunar-scar";
  };

  home.packages = with pkgs; [
    eza
    ripgrep
    fzf

    # Nice command line tools
    which
    tree
    file
    pciutils
    
    # Nix-related
    nix-output-monitor
  ];

  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    settings = {
      user.name = "shizumu-iruka";
      user.email = "github@kairi6.anonaddy.com";
    };
  };

  programs.neovim.enable = true;
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  home.stateVersion = "25.11";
}
