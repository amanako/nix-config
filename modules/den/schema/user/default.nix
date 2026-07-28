{
  den,
  lib,
  ...
}: {
  den.schema.user = let
    inherit (den.lib) policy;
  in {
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
      (
        policy.when (
          {user, ...}:
            den.aspects.dev.shells
            |> lib.filterAttrs (n: v: (v |> builtins.isAttrs) && !(n |> lib.hasPrefix "_"))
            |> builtins.attrNames
            |> lib.remove "default-shell-setter"
            |> lib.any (shell: user.hasAspect den.aspects.dev.shells)
        )
        (policy.include den.aspects.dev.shells)
      )
    ];

    classes = lib.mkDefault ["homeManager"];
  };
}
