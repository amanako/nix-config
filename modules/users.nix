{ pkgs, inputs, ... }:

{
  # Define a user account.
  users.users = {
    lunar-scar= {
      isNormalUser = true;
      extraGroups = [ 
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
        #inputs.home-manager.packages.${pkgs.system}.default
      ];
      shell = pkgs.fish;
    };
  };

  programs.starship.presets = [ "gruvbox-rainbow" ];
}
