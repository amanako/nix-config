{ pkgs, ... }:

{

  let
  {
    my-user = lunar-scar;
  }
  in 
  {
    # Define a user account.
    users.users.my-user = {
      isNormalUser = true;
      extraGroups = [ "networkmanager" "wheel" ];
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
}
