{ inputs, lib, ... }:

{
  flake-file.inputs = {
    flake-file.url = "github:vic/flake-file";
    den.url = lib.mkDefault "github:vic/den";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  imports = [
    (inputs.flake-file.flakeModules.dendritic or { })
    (inputs.den.flakeModules.dendritic or { })
  ];
}
