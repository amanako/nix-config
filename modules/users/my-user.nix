{ pkgs, ... }:

{
  users.users.lunar-scar = {
    isNormalUser = true;
    extraGroups = [ 
      "wheel"
      "networkmanager"
    ];
    initialPassword = "koko";
    shell = pkgs.fish;
  };
}
