{lib, ...}: {
  den.aspects.services.syncthing-client = {
    description = "Per-user Syncthing client for syncing the shared book library.";

    userSettings = {
      syncPath = lib.mkOption {
        type = lib.types.str;
        default = "Books";
        example = "Documents/Books";
        description = ''
          Directory, relative to the home directory, where the shared library
          should be synced. It is persisted on impermanent hosts. Use the same
          path when accepting the folder in the Syncthing web UI.
        '';
      };
    };

    persistUser = {user, ...}: {
      directories = [
        ".local/state/syncthing"
        ".config/syncthing"
        user.settings.services.syncthing-client.syncPath
      ];
    };

    hm.services.syncthing.enable = true;
  };
}
