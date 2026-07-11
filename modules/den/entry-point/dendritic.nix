{inputs, ...}: {
  imports = [
    (inputs.flake-file.flakeModules.dendritic or {})
    (inputs.den.flakeModules.dendritic or {})
  ];

  flake-file = {
    inputs = {
      flake-file.url = "github:denful/flake-file";
      den.url = "github:denful/den";
      flake-parts.url = "github:hercules-ci/flake-parts";
    };

    nixConfig = {
      extra-substituters = ["https://vic.cachix.org"];
      extra-trusted-public-keys = ["vic.cachix.org-1:1fQNG1DxLTGd47MBAtr/IrUYIk+TTXDojOItpqFoxII="];
    };
  };
}
