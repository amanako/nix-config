{ inputs, ... }:

{
  imports = [
    inputs.flake-parts.flakeModules.modules
    inputs.den.flakeModule
  ];

  systems = [
    "x86_64-linux"
    "x64_64-darwin"
    "aarch64-linux"
    "aarch64-darwin"
  ];
}
