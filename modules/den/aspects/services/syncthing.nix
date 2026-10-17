{den, ...}: {
  den.aspects.services.syncthing.book-serve = {
    description = "Always-on Syncthing hub for syncing the shared book library to other devices.";

    includes = [
      den.aspects.services.book-library
    ];

    persistHost.directories = ["/var/lib/syncthing"];

    nixos = {
      services.syncthing = {
        enable = true;
        openDefaultPorts = true;

        # Keep pairing and folder sharing done through the web UI instead of
        # declaring device IDs here: a declarative folder would reset manually
        # shared devices on every restart.
        overrideDevices = false;
        overrideFolders = false;
      };

      users.users.syncthing.extraGroups = ["books"];
    };
  };
}
