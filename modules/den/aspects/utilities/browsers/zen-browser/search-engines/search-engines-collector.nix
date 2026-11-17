{
  zen-browser.searchEnginesCollector = {
    zenProfileSettings = {
      zenSearchEngines,
      pkgs,
      lib,
      ...
    }: {
      search.engines = let
        iconSize = "48"; # Possible values: 16, 22, 24, 32, 42, 48, 64, 84, 96
        iconBasePath = "${pkgs.papirus-icon-theme}/share/icons/Papirus/${iconSize}x${iconSize}";
        defaultIcon = "${iconBasePath}/apps/distributor-logo-nixos.svg"; # Fallback icon to use if none specified
        # den (post #625, PR #625) defers aspect functions that reference
        # args outside `{ lib } ∪ scopeCtx` (e.g. pkgs / iconBasePath) as
        # config-thunk markers `{ __configThunk = true; __fn = <orig fn>; ... }`
        # instead of force-resolving them. den's own module wrapper resolves
        # den-arg thunks via `resolveMarkers`, but it does not descend into a
        # list we iterate here — so we unwrap each marker the same way,
        # supplying the args the engine originally expected.
        # Similar pattern is used in other aspects.
        resolveEngine = engine: let
          fn =
            if builtins.isAttrs engine && engine ? __fn
            then engine.__fn
            else engine;
        in
          if builtins.isFunction fn
          then fn {inherit pkgs iconBasePath;}
          else engine;
      in
        zenSearchEngines
        |> map resolveEngine
        |> lib.foldl lib.recursiveUpdate {}
        |> lib.mapAttrs (_: engine: {
          inherit (engine) name;
          icon = engine.icon or defaultIcon;

          urls = [
            {
              inherit (engine) template;
            }
          ];

          definedAliases = engine.aliases;
        });
    };
  };
}
