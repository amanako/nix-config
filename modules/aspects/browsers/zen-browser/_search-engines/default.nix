{
  pkgs,
  lib,
  ...
}: let
  iconSize = "48"; # Possible values: 16, 22, 24, 32, 42, 48, 64, 84, 96
  iconBasePath = "${pkgs.papirus-icon-theme}/share/icons/Papirus/${iconSize}x${iconSize}";
  defaultIcon = "${iconBasePath}/apps/distributor-logo-nixos.svg"; # Fallback icon to use if none specified

  mkEngines = import ./factory.nix {inherit defaultIcon;};

  engineFiles = [
    ./dictionaries.nix
    ./wiki.nix
    ./nixos.nix
  ];

  # Merge all files/modules as attributes passing them iconBasePath to allow for choosing of icons
  rawEngines = lib.attrsets.mergeAttrsList (
    map (file: import file {inherit iconBasePath;}) engineFiles
  );
in
  mkEngines rawEngines
