{ pkgs, ... }:

{
  home.packages = with pkgs; [
    protonup-qt
    lutris
		thunar
		kdePackages.okular
		youtube-tui

    # Nice command line tools
    which
    file
    pciutils
    usbutils
		ripgrep
    fastfetch
		p7zip
		unrar
		bat
    
    # Compatibility
		xwayland-satellite

    wineWow64Packages.stable
  ];
}
