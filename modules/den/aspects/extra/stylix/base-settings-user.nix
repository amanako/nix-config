{lib, ...}: {
  den.aspects.extra.stylix-user.base-settings = {
    description = "Base stylix theming defaults for user: theme, fonts, and icon pack.";
    # Fixes E79 spam error on nixvim startup due to broken variable expanding.
    # Reference commit: fix(nixvim): remove constant E79 error on startup + QOL.
    stylixHMSettings.targets.kde.enable = false;

    userSettings = {
      theme = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "catppuccin-mocha";
        description = "Base16 scheme slug from `pkgs.base16-schemes` overriding the system theme for this user. Unset follows the host theme.";
      };
    };

    hm = {
      user,
      lib,
      pkgs,
      ...
    }: let
      inherit (user.preferences) monofont;
      cfg = user.settings.extra.stylix-user.base-settings or null;
      schemePath = pkgs: name: "${pkgs.base16-schemes}/share/themes/${name}.yaml";
      # Each scheme file has a `variant` node ("light" or "dark"), which both stylix
      # and the package variants support, so it maps directly to polarity.
      getPolarityOf = scheme:
        scheme
        |> builtins.readFile
        |> builtins.match ".*variant: \"(light|dark)\".*"
        |> lib.head;
    in {
      stylix = lib.mkMerge [
        {
          fonts.monospace = {
            inherit (monofont) name;
            package = lib.attrByPath (lib.splitString "." monofont.package) null pkgs;
          };
        }
        (lib.optionalAttrs (cfg != null && cfg.theme != null) (let
          scheme = schemePath pkgs cfg.theme;
        in {
          base16Scheme = scheme;
          polarity = getPolarityOf scheme;
        }))
      ];
    };
  };
}
