{ defaultIcon, ... }:

engines:

builtins.mapAttrs
  (_: engine:
    {
      inherit (engine) name;
      icon = engine.icon or defaultIcon;

      urls = [
        {
          inherit (engine) template;
        }
      ];

      definedAliases = engine.aliases;
    }
  )
  engines
