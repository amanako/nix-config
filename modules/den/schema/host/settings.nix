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
  #   - a deferred function receiving entity context ({ host, ... }: <one of the above>)
  # Normalize to module-shaped. `context` is passed to the deferred form so
  # settings blocks can reference `host` (and `lib`) without hitting the
  # module-system circular dependency of accessing `_module.args.host`.
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
      (node ? hostSettings)
      || lib.any (k: !(skipKey k) && hasSettingsDeep (node.${k} or null)) (builtins.attrNames node)
    );

  # Build the submodule for one aspect-tree node, mirroring the tree.
  # Merge the node's OWN settings options with recursion into its
  # settings-bearing children. `context` is threaded through so deferred
  # settings functions receive the entity context.
  nodeModule = context: node: let
    ownSettings =
      if node ? hostSettings
      then reshapeSettings node.hostSettings context
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
            description = "Settings under ${name}";
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
  # hosts that don't include an aspect don't surface "dead" settings for it.
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
      children = lib.filterAttrs (k: v: builtins.isAttrs v && !(skipKey k)) node;
      pruned = lib.mapAttrs (k: v: pruneTree includedSet (prefix ++ [k]) v) children;
      kept = lib.filterAttrs (_: v: v != null) pruned;
      selfIncluded = includedSet ? ${lib.concatStringsSep "/" prefix};
    in
      if selfIncluded || kept != {}
      then (removeAttrs node (builtins.attrNames children)) // kept
      else null;
in {
  den.reservedKeys = ["hostSettings"];

  # Function-form schema entry: receives the entity context at evaluation
  # time (like preferences.nix), so deferred hostSettings can reference host.
  den.schema.host = args @ {config, ...}: let
    host = args.host or config;
    context = {
      inherit host lib;
    };

    # The set of aspect attrpaths this host actually includes, derived from
    # den's resolved aspect list (config.aspects). Each node carries
    # `identity` as a slash-joined FQN (e.g. "core/displayManagers/ly"), which
    # matches the aspect-tree attrpath. Keyed by that string so membership checks
    # need no path helpers. If resolution isn't available yet we fall back to
    # the full aspect tree (no pruning) to stay safe.
    includedSet =
      lib.foldl'
      (acc: node: let
        id = node.identity or "";
      in
        if id == ""
        then acc
        else acc // {${id} = true;})
      {}
      (
        if config ? resolved
        then config.aspects
        else []
      );

    aspectTree = pruneTree includedSet [] fullAspectTree;

    mkSettingsType = context: types.submodule (nodeModule context aspectTree);
  in {
    # The generated, auto-discovered settings namespace:
    options.settings =
      mkOption {
        type = mkSettingsType context;
        default = {};
        description = "Per-aspect typed settings for host";
      }
      // {
        identity = false;
      };
  };
}
