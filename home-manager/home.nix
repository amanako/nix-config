{ inputs, pkgs, ... }:

{
  home = {
    username = "lunar-scar";
    homeDirectory = "/home/lunar-scar";
  };

  imports = [
    inputs.dms.homeModules.dank-material-shell
    inputs.dms.homeModules.niri
  ];

  home.packages = with pkgs; [
    eza
    ripgrep
    fzf

    # Nice command line tools
    which
    tree
    file
    pciutils
    usbutils
    
    # Nix-related
    nix-output-monitor

    # Fallback options
    alacritty
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
  programs.dank-material-shell = {
    enable = true;
    niri = {
      enableSpawn = true;
      enableKeybinds = true;
      includes.enable = false;
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  home.stateVersion = "25.11";
}
