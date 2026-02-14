{ pkgs, ... }:

{
  # Define a user account.
  users.users.lunar-scar= {
    isNormalUser = true;
    extraGroups = [ 
      #"networkmanager"
      "wheel"
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
}
