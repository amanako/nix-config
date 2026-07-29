{lib, ...}: let
  # Fold per-aspect conflict contributions ({ warnings = [...]; assertions = [...] })
  # into config.warnings / config.assertions for the given entity scope.
  collect = {
    entity,
    config,
    conflicts,
  }: let
    allWarnings = lib.concatMap (entry: entry.warnings or []) conflicts;
    allAssertions = lib.concatMap (entry: entry.assertions or []) conflicts;

    resolve = conflict: let
      fn =
        if builtins.isAttrs conflict && conflict ? __fn
        then conflict.__fn
        else conflict;
    in
      if builtins.isFunction fn
      then let
        fnArgs = lib.functionArgs fn;
        ctxArgs =
          entity
          // lib.optionalAttrs (fnArgs ? config) {
            inherit config;
          };
      in
        fn (ctxArgs
          // {
            inherit lib;
          })
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
      args = {
        inherit (c) subject target;
      };
    in
      if builtins.isFunction c.message
      then args |> c.message
      else c.message;

    # Warnings are displayed after evaluation when placed in warnings list.
    # Additionally display warnings during evaluation.
    warnAll = msgs:
      msgs |> map (msg: lib.warn msg msg);
  in {
    config.warnings = warnAll (map formatConflict resolvedWarnings);

    config.assertions =
      map (c: {
        inherit (c) assertion;
        message = formatConflict c;
      })
      resolvedAssertions;
  };
in {
  den.aspects.basic.conflicts-collector = {
    description = ''
      Aspect collecting and assembling all conflicts - warnings and assertions united.
      Include in both schemas: the `nixos` lambda folds host-scope conflicts
      (from the `hostConflicts` quirk) into NixOS config, the `hm` lambda folds
      user-scope conflicts (from the `userConflicts` quirk) into Home Manager config.
    '';

    nixos = {
      hostConflicts,
      host,
      config,
      ...
    }:
      collect {
        conflicts = hostConflicts;
        inherit config;
        entity = {
          inherit host;
        };
      };

    hm = {
      userConflicts,
      user,
      config,
      ...
    }:
      collect {
        conflicts = userConflicts;
        inherit config;
        entity = {
          inherit user;
        };
      };
  };
}
