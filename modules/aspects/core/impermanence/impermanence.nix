{
  den,
  inputs,
  ...
}: {
  flake-file.inputs.impermanence.url = "github:nix-community/impermanence";

  den.aspects.core.impermanence = {
    includes = [
      den.aspects.core.impermanence.btrfs
      den.aspects.core.impermanence.persistSystemCollector
      den.aspects.core.impermanence.persistUserCollector
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
    }: {
      imports = [
        inputs.impermanence.nixosModules.impermanence
      ];
      fileSystems =
        {
          "${host.impermanence.persistenceDir}".neededForBoot = true;
        }
        // lib.optionalAttrs (!host.impermanence.enableUser) {
          "/home".neededForBoot = true;
        };

      environment.persistence.${host.impermanence.persistenceDir}.hideMounts = true;
    };
  };
}
