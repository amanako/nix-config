{ pkgs, ... }:

{
  users.users.lunar-scar.packages = with pkgs; [
    mesa-demos
    unrar
  ];
}
