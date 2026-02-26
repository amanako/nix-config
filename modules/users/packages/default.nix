{ pkgs, ... }:

{
  users.users.lunar-scar.packages = with pkgs; [
    unrar
		kdePackages.okular
    xwayland-satellite
    youtube-tui
  ];
}
