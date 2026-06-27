{
  den,
  lib,
  ...
}: {
  den.schema.user = {
    includes = [
      den.batteries.define-user
      den.batteries.mutual-provider
      den.policies.hm-shorthand
      den.aspects.basic.desktopEntriesCollector
      den.aspects.basic.homeBackup
      (
        {user}:
          if user.isPrimaryUser
          then den.batteries.primary-user
          else {}
      )
    ];

    classes = lib.mkDefault ["homeManager"];
  };
}
