{inputs, ...}: {
  flake-file.inputs.disko.url = "github:nix-community/disko";

  den.aspects.core.disko = {
    nixos = {
      host,
      lib,
      ...
    }:
      lib.optionalAttrs (host.disko.devices != {}) {
        imports = [inputs.disko.nixosModules.disko];
        inherit (host) disko;
      };
  };
}
