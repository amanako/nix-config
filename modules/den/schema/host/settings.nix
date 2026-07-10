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

  settingsType = let
    # Keys that are NOT child aspects: structural keys (includes, nixos, …),
    # plus your framework's registered class names and quirk/extension keys.
    # Adapt these three sources to your own framework.
    inherit (den.lib.aspects.fx.keyClassification) structuralKeysSet;
    classKeys = den.classes or {};
    quirkKeys = den.quirks or {};
    skipKey = k: structuralKeysSet ? ${k} || classKeys ? ${k} || quirkKeys ? ${k};

    # A settings block may be a plain options attrset ({ foo = mkOption {...}; })
    # OR module-shaped ({ imports; config; options; }). Normalize to the latter.
    reshapeSettings = raw: let
      # Allow settings to be a function or a plain attrset.
      settings =
        if builtins.isFunction raw
        then raw {}
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
    # settings-bearing children.
    nodeModule = node: let
      ownSettings =
        if node ? hostSettings
        then reshapeSettings node.hostSettings
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
              type = types.submodule (nodeModule child);
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
  in
    types.submodule (nodeModule (
      (den.aspects or {})
      // lib.concatMapAttrs (
        nsName: ns: let
          skipNsKey = k: structuralKeysSet ? ${k};
          aspectNames = lib.filter (k: !(skipNsKey k)) (builtins.attrNames ns);
        in
          if aspectNames == []
          then {}
          else {${nsName} = lib.genAttrs aspectNames (k: ns.${k});}
      ) (den.ful or {})
    ));
in {
  den.reservedKeys = ["hostSettings"];

  den.schema.host.imports = [
    {
      # The generated, auto-discovered settings namespace:
      options = {
        settings =
          mkOption {
            type = settingsType;
            default = {};
            description = "Per-aspect typed settings for host";
          }
          // {
            identity = false;
          };
      };
    }
  ];
}
