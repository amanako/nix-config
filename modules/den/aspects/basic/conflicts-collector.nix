{
  den.aspects.basic.conflicts-collector = {
    hm = {
      conflicts,
      user,
      lib,
      ...
    }: let
      # conflicts is a list of per-aspect contributions, each being
      # { warnings = [...]; assertions = [...] }.  Extract and flatten them.
      allWarnings = lib.concatMap (entry: entry.warnings or []) conflicts;
      allAssertions = lib.concatMap (entry: entry.assertions or []) conflicts;

      resolve = conflict: let
        fn =
          if builtins.isAttrs conflict && conflict ? __fn
          then conflict.__fn
          else conflict;
      in
        if builtins.isFunction fn
        then fn {inherit user lib;}
        else conflict;

      resolvedWarnings =
        allWarnings
        |> map resolve
        |> lib.concatLists;

      resolvedAssertions =
        allAssertions
        |> map resolve
        |> lib.concatLists;

      formatConflict = c: let
        args = {inherit (c) subject target;};
      in
        if builtins.isFunction c.message
        then c.message args
        else c.message;

      # Warnings are displayed after evaluation when placed in warnings list.
      # Additionally display warnings during evaluation.
      warnAll = msgs: map (msg: lib.warn msg msg) msgs;
    in {
      config.warnings = warnAll (map formatConflict resolvedWarnings);

      config.assertions =
        map (c: {
          inherit (c) assertion;
          message = formatConflict c;
        })
        resolvedAssertions;
    };
  };
}
