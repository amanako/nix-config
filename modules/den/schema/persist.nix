{
  inputs,
  den,
  lib,
  ...
}: let
  persistClass = {
    host,
    user,
    ...
  }:
    den.batteries.forward {
      each = [
        "host"
        "user"
      ];
      fromClass = target: "persys${lib.optionalString (target == "user") "User"}";
      intoClass = _item: "nixos";
      intoPath = target:
        [
          "environment"
          "persistence"
          host.impermanence.persistenceDir
        ]
        ++ lib.optionals (target == "user") [
          "users"
          user.userName
        ];
      adaptArgs = {config, ...}: {
        osConfig = config;
      };
      guard = {options, ...}: options ? environment.persistence;
    };
in {
  flake-file.inputs.impermanence.url = "github:nix-community/impermanence";

  den = {
    aspects.impermanence = {host, ...}: {
      includes = [persistClass];
      nixos = {
        imports = [inputs.impermanence.nixosModules.impermanence];
        # This should be minimal for a truly pure setup
        fileSystems."${host.impermanence.persistenceDir}".neededForBoot = true;
      };
    };

    schema.host.includes = [
      den.aspects.impermanence
    ];
  };
}
