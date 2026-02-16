{ pkgs, ... }:

{
  home.packages = with pkgs; [
    kitty
    vivaldi
    yazi
    starship
    zoxide
    fastfetch
    sl
    protonup-qt
    lutris
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
}
