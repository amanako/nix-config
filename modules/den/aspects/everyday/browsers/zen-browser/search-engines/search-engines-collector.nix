{
  zen-browser.searchEnginesCollector = {
    zenUserSettings = {
      zenSearchEngines,
      pkgs,
      lib,
      ...
    }: {
      search.engines = let
        iconSize = "48"; # Possible values: 16, 22, 24, 32, 42, 48, 64, 84, 96
        iconBasePath = "${pkgs.papirus-icon-theme}/share/icons/Papirus/${iconSize}x${iconSize}";
        defaultIcon = "${iconBasePath}/apps/distributor-logo-nixos.svg"; # Fallback icon to use if none specified
      in
        zenSearchEngines
        |> map (
          engine:
            if builtins.isFunction engine
            then
              engine {
                inherit
                  pkgs
                  iconBasePath
                  ;
              }
            else engine
        )
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
