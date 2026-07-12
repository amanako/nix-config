{
  den,
  lib,
  inputs,
  ...
}: {
  flake-file.inputs.impermanence.url = "github:nix-community/impermanence";

  den.aspects.core.impermanence = let
    inherit
      (lib)
      mkOption
      types
      ;
  in {
    hostSettings = {host, ...}: {
      persistenceDir = mkOption {
        type = types.nullOr types.path;
        default = "/nix/persist/system";
        example = "/persist";
        description = "Directory for impermanence persistent storage.";
      };

      dontEnableUsers = mkOption {
        type = types.bool;
        default =
          host.users
          |> lib.attrValues
          |> builtins.any (_: true);
        example = false;
        description = ''
          Whether to not enable impermanence module for users, that is impermanence for `/home` directory.
          Note that for this option to work `/home` must be an existing mountpoint marked as neededForBoot,
          which is done automatically when `den.aspects.core.impermanence` aspect is included.
        '';
      };
    };

    includes = [
      den.aspects.core.impermanence.btrfs
      den.aspects.core.impermanence.persist-system-collector
    ];

    provides.to-users.includes = [
      den.aspects.core.impermanence.persist-user-collector
    ];

    persistSystem = {
      directories = [
        # Without this dir all users/groups without specified
        # uids/gids will have them reassigned on reboot.
        "/var/lib/nixos"

        # Popup lecturing on sudo usage
        "/var/db/sudo/lectured"

        # Time stamps for systemd tasks which should help with remembering timers countdown
        "/var/lib/systemd/timers"
      ];

      files = [
        # Fix wpa/network errors
        "/etc/machine-id"
      ];
    };

    nixos = {
      host,
      lib,
      ...
    }: let
      cfg = host.settings.core.impermanence;
    in {
      imports = [
        inputs.impermanence.nixosModules.impermanence
      ];
      fileSystems =
        {
          "${cfg.persistenceDir}".neededForBoot = true;
        }
        // lib.optionalAttrs (cfg.dontEnableUsers) {
          "/home".neededForBoot = true;
        };

      environment.persistence.${cfg.persistenceDir}.hideMounts = true;
    };
  };
}
