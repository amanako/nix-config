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
      # TODO: Implement check for fileSystems."/home".neededForBoot == true
      # And disable class via guard if user doesn't have ephemeral home
      guard = {options, ...}: options ? environment.persistence;
    };
in {
  flake-file.inputs.impermanence.url = "github:nix-community/impermanence";

  # Workaround for config.includes not working.
  # From my experience it should be avoided since it fails.
  # Using it causes error for this aspect:
  # error: attribute 'persistence' missing
  den = {config, ...}: {
    schema.host.options.impermanence = let
      defaultPersysDir = "/nix/persist/system";
    in
      lib.mkOption {
        type = lib.types.submodule {
          options.enable = lib.mkOption {
            type = lib.types.bool;
            default = config.impermanence.persistenceDir != defaultPersysDir;
            description = "Whether to enable impermanence module";
          };

          options.persistenceDir = lib.mkOption {
            type = lib.types.str;
            default = defaultPersysDir;
            description = "Directory for impermanence persistent storage";
          };
        };
      };

    schema.host.includes = [den.aspects.impermanence];

    aspects.impermanence = {host, ...}: {
      includes = [persistClass];
      nixos = {
        imports = [inputs.impermanence.nixosModules.impermanence];
        # This should be minimal for a truly pure setup
        fileSystems."${host.impermanence.persistenceDir}".neededForBoot = true;
      };
    };
  };
}
