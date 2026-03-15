{ lib, config, ... }:

{
  config = {
    programs.nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep 5 --keep-since 3d";
    };
    enableNH = lib.mkForce true;
  };

  options.enableNH = lib.mkOption {
    default = false;
    type = lib.types.bool;
    description = "Enable NH module for greater utility";
  };
}
