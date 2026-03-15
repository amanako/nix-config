{ lib, username, ... }:

{
  home = {
    username = username;
    homeDirectory = "/home/${username}";
  };

  imports = [
    ./programs
    ./fcitx5
    ./env/session-variables.nix
  ];

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "lutris"
      "steam"
      "steam-unwrapped"
      "unrar"
    ];
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  home.stateVersion = "25.11";
}
