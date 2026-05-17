{
  den,
  lib,
  inputs,
  ...
}: {
  flake-file.inputs.disko.url = "github:nix-community/disko";

  den.schema = {
    host.includes = [den.aspects.disko];

    host.options.disko.devices = lib.mkOption {
      type = lib.types.attrs;
      description = "Disko device configuration";
      default = {};
    };
  };

  den.aspects.disko.nixos = {host, ...}:
    lib.optionalAttrs (host.disko.devices != {}) {
      imports = [inputs.disko.nixosModules.disko];
      inherit (host) disko;
    };
}
