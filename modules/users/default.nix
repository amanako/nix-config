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
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJu+Btx2UdY+nVSsHXs9BfSIJfeZuUgFSDHqAFvWD8rN codeberg@kairi6.anonaddy.com"
    ];
  };
}
