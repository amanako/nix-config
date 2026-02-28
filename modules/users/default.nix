{ pkgs, ... }:

{
  users.users.lunar-scar = {
    isNormalUser = true;
    extraGroups = [ 
      "wheel"
      "networkmanager"
			"seat"
    ];
    initialPassword = "koko";
    shell = pkgs.fish;
  };
}
