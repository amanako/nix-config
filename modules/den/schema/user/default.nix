{
  __findFile,
  lib,
  ...
}: {
  den.schema.user = {
    includes = [
      <den.batteries.define-user>
      <den.batteries.mutual-provider>
      <homeBackup>
    ];

    classes = lib.mkDefault ["homeManager"];
  };

  # Opinionated: Skip rebuilding every time when overriding a file
  # Take into consideration that with ephemeral setup this file will
  # be wiped when rebooting
  den.aspects.homeBackup.nixos = {user, ...}:
    lib.optionalAttrs (lib.elem "homeManager" user.classes) {
      home-manager.backupFileExtension = "backup";
    };
}
