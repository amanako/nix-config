# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
      ../modules/graphics.nix
      ../modules/services.nix
      ../modules/boot-loader.nix
      ../modules/fish.nix
      ../modules/fonts.nix
      ../modules/users.nix
    ];

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Define hostname
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
  };

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Define locale
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocales = [
    "ja_JP.UTF-8/UTF-8"
  ];

  programs = {
    gamemode.enable = true;
  };

  environment.variables = {
    EDITOR = "nvim";
  };

  # Allow unfree packages.
  nixpkgs.config.allowUnfree = true;

  # Add system packages.
  environment.systemPackages = with pkgs; [
    git
    neovim
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}

