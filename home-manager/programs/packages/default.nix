{ pkgs, ... }:

{
  home.packages = with pkgs; [
    protonup-qt
    lutris
		thunar

    # Nice command line tools
    which
    file
    pciutils
    usbutils
		ripgrep
    fastfetch
    
    # Nix-related
    nix-output-monitor

    wineWow64Packages.stable
  ];
}
