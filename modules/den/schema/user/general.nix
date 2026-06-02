{
  lib,
  __findFile,
  ...
}: {
  den.schema.user = {
    options.isPrimaryUser = lib.mkOption {
      example = true;
      type = lib.types.bool;
      description = ''
        Whether this user is a primary user of the system.
        This option must be configured, instead assertion fails.
      '';
    };

    includes = [
      <den.batteries.define-user>
      <homeBackup>
      <den.batteries.mutual-provider>
      (
        {user}:
          if user.isPrimaryUser
          then <den.batteries.primary-user>
          else {}
      )
    ];

    config.classes = lib.mkDefault ["homeManager"];
  };

  # Opinionated: Skip rebuilding every time when overriding a file
  # Take into consideration that with ephemeral setup this file will
  # be wiped when rebooting
  den.aspects = {
    homeBackup.nixos = {
      user,
      lib,
      ...
    }:
      lib.optionalAttrs (lib.elem "homeManager" user.classes) {
        home-manager.backupFileExtension = "backup";
      };
  };
}
