{
  __findFile,
  inputs,
  lib,
  ...
}: {
  flake-file.inputs.disko.url = "github:nix-community/disko";

  den = {
    aspects = {
      disko = {host, ...}:
        lib.optionalAttrs (host.disko.devices != {}) {
          nixos = {
            imports = [inputs.disko.nixosModules.disko];
            inherit (host) disko;
          };
        };

      timezone.nixos = {host, ...}: {
        time.timeZone = host.timeZone or "UTC";
      };

      base-host.includes = [
        <den.batteries.hostname>
        <disko>
        <timezone>
      ];
    };

    schema = {
      host.includes = [
        <base-host>
      ];

      user.includes = [
        <den.batteries.define-user>
        <den.batteries.mutual-provider>
      ];
    };
  };
}
