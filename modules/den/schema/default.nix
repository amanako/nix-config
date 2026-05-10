{
  inputs,
  den,
  lib,
  ...
}: {
  flake-file.inputs = {
    disko.url = "github:nix-community/disko";
  };

  den.aspects.disko = {host, ...}:
    lib.optionalAttrs (host.disko.devices != {}) {
      nixos = {
        imports = [inputs.disko.nixosModules.disko];
        inherit (host) disko;
      };
    };

  den.aspects.timezone = {host, ...}: {
    nixos.time.timeZone = host.timeZone or "UTC";
  };

  den.aspects.base-host.includes = [
    den._.hostname

    den.aspects.disko
    den.aspects.timezone
  ];

  den.default.includes = [
    den.aspects.overlays
  ];

  den.schema.host.includes = [
    den.aspects.base-host
  ];

  den.schema.user.includes = [
    den._.define-user
    den._.mutual-provider
  ];
}
