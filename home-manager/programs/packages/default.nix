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
		unzip
		unrar
		bat

		# Development
		clang
		cmake
		gnumake
    
    wineWow64Packages.stable
  ];
}
