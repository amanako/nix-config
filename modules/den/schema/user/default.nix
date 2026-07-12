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
      den.aspects.basic.desktop-entries-collector
      den.aspects.basic.home-backup
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
