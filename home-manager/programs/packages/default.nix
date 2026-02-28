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
    
    # Compatibility
		xwayland-satellite

    # Nix-related
    nix-output-monitor

    wineWow64Packages.stable
  ];
}
