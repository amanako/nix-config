{
  den,
  lib,
  ...
}: {
  den.schema.user = {
    includes = [
      den.batteries.define-user
      den.batteries.host-aspects
      den.policies.hm-shorthand
      den.aspects.basic.conflicts-collector
      den.aspects.basic.desktop-entries-collector
      den.aspects.basic.home-backup
      (
        {user}:
          if user.isPrimaryUser
          then den.batteries.primary-user
          else {}
      )
      den.aspects.dev.shells
    ];

    classes = lib.mkDefault ["homeManager"];
  };
}
