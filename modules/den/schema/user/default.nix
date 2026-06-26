{
  den,
  lib,
  ...
}: {
  den.schema.user = {
    includes = [
      den.batteries.define-user
      den.aspects.basic.homeBackup
      den.batteries.mutual-provider
      (
        {user}:
          if user.isPrimaryUser
          then den.batteries.primary-user
          else {}
      )
    ];
  };

  den.schema.user.classes = lib.mkDefault ["homeManager"];
}
