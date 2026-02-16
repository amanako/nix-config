{ pkgs, ... }:

{
  users.users.lunar-scar = {
    isNormalUser = true;
    extraGroups = [ 
      "wheel"
      "networkmanager"
    ];
    initialPassword = "koko";
    packages = with pkgs; [
      kitty
      vivaldi
      yazi
      starship
      zoxide
      fastfetch
      sl
      protonup-qt
      lutris
    ];
    shell = pkgs.fish;
  };
}
