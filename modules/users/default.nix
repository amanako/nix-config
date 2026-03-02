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
		openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKmiabb2d60IC4q/jCD5KX/uLlZccZ+pK6G9Tp2NVQbe gitlab@kairi6.anonaddy.com"
		];
  };
}
