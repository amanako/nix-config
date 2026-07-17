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

      mountHomeDir = mkOption {
        type = types.bool;
        default =
          host.users
          |> lib.attrValues
          |> builtins.any (_: true);
        example = false;
        description = ''
          Whether to mount `/home` directory as persistent, for users of the host.
          A safe option for ones who don't like to experiment too much.
          Defaults to true if host has at least one user.
          Note that for this option to work `/home` must be an existing mountpoint marked as neededForBoot,
          which is done automatically when `den.aspects.core.impermanence` aspect is included and this option is set to true.
        '';
      };
    };

    includes = [
      den.aspects.core.impermanence.btrfs
      den.aspects.core.impermanence.persist-host-collector
    ];

    provides.to-users.includes = [
      den.aspects.core.impermanence.persist-user-collector
    ];

    persistHost = {
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
        // lib.optionalAttrs (cfg.mountHomeDir) {
          "/home".neededForBoot = true;
        };

      environment.persistence.${cfg.persistenceDir}.hideMounts = true;
    };
  };
}
