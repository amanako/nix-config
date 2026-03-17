{
  home = {
    username = "lunar-scar";
    homeDirectory = "/home/lunar-scar";
  };

  imports = [
    ./programs
    ./fcitx5
    ./env/session-variables.nix
  ];

  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  home.stateVersion = "25.11";
}
