{
  pkgs,
  config,
  lib,
  username,
  git,
  ...
}:

let
  lemursGroup = if config.lemurs.enable then [ "seat" ] else [ ];
in
{
  users.users.${username} = {
    isNormalUser = true;
    extraGroups = lemursGroup ++ [
      "wheel"
      "networkmanager"
    ];

    initialPassword = "koko";
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKmiabb2d60IC4q/jCD5KX/uLlZccZ+pK6G9Tp2NVQbe ${git.email}"
    ];
  };
}
