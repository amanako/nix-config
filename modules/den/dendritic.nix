{
  inputs,
  lib,
  ...
}: {
  flake-file = {
    inputs = {
      flake-file.url = "github:vic/flake-file";
      den.url = lib.mkDefault "github:vic/den";
      flake-parts.url = "github:hercules-ci/flake-parts";
    };

    nixConfig = {
      extra-substituters = ["https://vic.cachix.org"];
      extra-trusted-public-keys = ["vic.cachix.org-1:1fQNG1DxLTGd47MBAtr/IrUYIk+TTXDojOItpqFoxII="];
    };
  };

  imports = [
    (inputs.flake-file.flakeModules.dendritic or {})
    (inputs.den.flakeModules.dendritic or {})
  ];
}
