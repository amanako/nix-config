{ inputs, lib, ... }:

{
  options.flake.hmModules = lib.mkOption {
    type = lib.types.attrsOf lib.types.unspecified;
    default = { };
  };
}
