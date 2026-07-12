{
  den,
  lib,
  ...
}: let
  inherit
    (lib)
    mkOption
    types
    ;

  # Keys that are NOT child aspects: structural keys (includes, nixos, …),
  # plus your framework's registered class names and quirk/extension keys.
  inherit (den.lib.aspects.fx.keyClassification) structuralKeysSet;
  classKeys = den.classes or {};
  quirkKeys = den.quirks or {};
  skipKey = k: structuralKeysSet ? ${k} || classKeys ? ${k} || quirkKeys ? ${k};

  # A settings block may be:
  #   - a plain options attrset ({ foo = mkOption {...}; })
  #   - module-shaped ({ imports; config; options; })
  #   - a deferred function receiving entity context ({ user, ... }: <one of the above>)
  # Normalize to module-shaped. `context` is passed to the deferred form so
  # settings blocks can reference `user` / `host` (and `lib`) without hitting the
  # module-system circular dependency of accessing `_module.args.user`.
  reshapeSettings = raw: context: let
    settings =
      if builtins.isFunction raw
      then raw context
      else raw;
    imports' = settings.imports or [];
    config' = settings.config or {};
  in {
    imports = imports';
    config = config';
    options = removeAttrs settings ["imports" "config"];
  };

  # True if this node, or anything beneath it, declares settings.
  hasSettingsDeep = node:
    builtins.isAttrs node
    && (
      (node ? userSettings)
      || lib.any (k: !(skipKey k) && hasSettingsDeep (node.${k} or null)) (builtins.attrNames node)
    );

  # Build the submodule for one aspect-tree node, mirroring the tree.
  # Merge the node's OWN settings options with recursion into its
  # settings-bearing children. `context` is threaded through so deferred
  # settings functions receive the entity context.
  nodeModule = context: node: let
    ownSettings =
      if node ? userSettings
      then reshapeSettings node.userSettings context
      else {
        imports = [];
        config = {};
        options = {};
      };

    settingChildren =
      lib.filterAttrs (
        k: v: !(skipKey k) && builtins.isAttrs v && hasSettingsDeep v
      )
      node;

    childOptions =
      lib.mapAttrs (
        name: child:
          mkOption {
            type = types.submodule (nodeModule context child);
            default = {};
            description = "Settings under ${name}.";
          }
      )
      settingChildren;

    # Distinct names again — keep statix from dropping the `or` default.
    ownImports = ownSettings.imports or [];
    ownConfig = ownSettings.config or {};
  in {
    imports = ownImports;
    config = ownConfig;
    options = (ownSettings.options or {}) // childOptions;
  };

  # The full aspect tree, including function-provided aspects
  # (den.ful). This is the universe of possible settings; it is pruned
  # per-entity below to only the aspects that entity actually includes, so
  # entities that don't include an aspect don't surface "dead" settings for it.
  fullAspectTree =
    (den.aspects or {})
    // lib.concatMapAttrs (
      nsName: ns: let
        skipNsKey = k: structuralKeysSet ? ${k};
        aspectNames = lib.filter (k: !(skipNsKey k)) (builtins.attrNames ns);
      in
        if aspectNames == []
        then {}
        else {${nsName} = lib.genAttrs aspectNames (k: ns.${k});}
    ) (den.ful or {});

  # Keep only the branches of the aspect tree that the entity resolves to
  # (transitively). Structural/leaf content of a kept node is preserved; a
  # node survives if it is itself an included aspect or any descendant is.
  pruneTree = includedSet: prefix: node:
    if !(builtins.isAttrs node)
    then node
    else let
      children = lib.filterAttrs (k: v: builtins.isAttrs v && !(skipKey k) && !(v._type or null == "option")) node;
      pruned = lib.mapAttrs (k: v: pruneTree includedSet (prefix ++ [k]) v) children;
      kept = lib.filterAttrs (_: v: v != null) pruned;
      selfIncluded = includedSet ? ${lib.concatStringsSep "/" prefix};
    in
      if selfIncluded || kept != {}
      then (removeAttrs node (builtins.attrNames children)) // kept
      else null;
in {
  den.reservedKeys = ["userSettings"];

  # Function-form schema entry: receives the entity context at evaluation
  # time (like preferences.nix), so deferred userSettings can reference user/host.
  den.schema.user = args @ {config, ...}: let
    user = args.user or config;
    host = args.host or null;
    context = {
      inherit user host lib;
    };

    # The set of aspect attrpaths this user should see settings for. A user
    # setting is relevant whenever the aspect that defines/reads it is active —
    # and that aspect may be included by the *host*. So union the user's own resolved aspects
    # with the host's resolved aspects. Each node carries `identity` as a
    # slash-joined FQN matching the aspect-tree attrpath; keyed by that string so
    # membership checks need no path helpers. Falls back to the full aspect tree
    # (no pruning) if resolution isn't available yet.
    includedSet = let
      entityAspects =
        if config ? resolved
        then config.aspects
        else [];
      hostAspects =
        if host != null && host ? resolved
        then host.aspects
        else [];
    in
      lib.foldl'
      (acc: node: let
        id = node.identity or "";
      in
        if id == ""
        then acc
        else acc // {${id} = true;})
      {}
      (entityAspects ++ hostAspects);

    aspectTree = pruneTree includedSet [] fullAspectTree;

    mkSettingsType = context: types.submodule (nodeModule context aspectTree);
  in {
    # The generated, auto-discovered settings namespace:
    options = {
      settings =
        mkOption {
          type = mkSettingsType context;
          default = {};
          description = "Per-aspect typed settings for user.";
        }
        // {
          identity = false;
        };
    };
  };
}
