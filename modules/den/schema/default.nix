{
  __findFile,
  inputs,
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
    <den/hostname>
    <disko>
    <timezone>
  ];

  den.default.includes = [
    <overlays>
  ];

  den.schema.host.includes = [
    <base-host>
  ];

  den.schema.user.includes = [
    <den/define-user>
    <den/mutual-provider>
  ];
}
