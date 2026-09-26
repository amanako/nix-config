{
  den.aspects.basic.home-backup = {
    description = ''
      Opinionated: Skip rebuilding every time when overriding a file
      Take into consideration that with ephemeral setup this file will
      be wiped when rebooting.
    '';

    nixos = {
      user,
      lib,
      ...
    }:
      lib.optionalAttrs (user.classes |> lib.elem "homeManager") {
        home-manager.backupFileExtension = "backup";
      };
  };
}
