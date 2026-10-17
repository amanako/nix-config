{lib, ...}: {
  den.aspects.extra.stylix.base-settings = let
    inherit
      (lib)
      mkOption
      types
      ;
  in {
    description = "Base stylix theming defaults: theme, fonts, and icon pack.";
    # Fixes E79 spam error on nixvim startup due to broken variable expanding.
    # Reference commit: fix(nixvim): remove constant E79 error on startup + QOL.
    stylixHMSettings.targets."kde".enable = false;

    hostSettings = {
      theme = mkOption {
        type = types.str;
        default = "gruvbox-material-dark-soft";
        example = "catppuccin-mocha";
        description = "Base16 scheme slug from `pkgs.base16-schemes` used for system-wide Stylix theming.";
      };

      polarity = mkOption {
        type = types.enum ["light" "dark"];
        default = "dark";
        description = "Polarity forced for system-wide Stylix theming.";
      };
    };

    userSettings = {
      theme = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "catppuccin-mocha";
        description = "Base16 scheme slug from `pkgs.base16-schemes` overriding the system theme for this user. Unset follows the host theme.";
      };

      polarity = mkOption {
        type = types.nullOr (types.enum ["light" "dark"]);
        default = null;
        description = "Polarity forced for this user's Stylix theming. Unset follows the host polarity.";
      };
    };

    nixos = {
      pkgs,
      config,
      host,
      ...
    }: let
      cfg = host.settings.extra.stylix.base-settings;
    in {
      stylix = {
        base16Scheme = "${pkgs.base16-schemes}/share/themes/${cfg.theme}.yaml";
        inherit (cfg) polarity;
        opacity = {
          applications = 0.87;
          desktop = 0.85;
          popups = 0.86;
          terminal = 0.85;
        };

        icons = {
          enable = true;
          package = pkgs.papirus-icon-theme;
          dark = "Papirus-Dark";
          light = "Papirus-Light";
        };

        fonts = {
          sansSerif = {
            package = pkgs.inter;
            name = "Inter";
          };
          serif = config.stylix.fonts.sansSerif;
          emoji = {
            package = pkgs.twemoji-color-font;
            name = "Twemoji";
          };
        };
      };
    };

    hm = {
      user,
      lib,
      pkgs,
      ...
    }: let
      inherit (user.preferences) monofont;
      cfg = lib.attrByPath ["extra" "stylix" "base-settings"] null user.settings;
    in {
      stylix = lib.mkMerge [
        {
          fonts.monospace = {
            inherit (monofont) name;
            package = lib.attrByPath (lib.splitString "." monofont.package) null pkgs;
          };
        }
        (lib.optionalAttrs (cfg != null && cfg.theme != null) {
          base16Scheme = "${pkgs.base16-schemes}/share/themes/${cfg.theme}.yaml";
        })
        (lib.optionalAttrs (cfg != null && cfg.polarity != null) {
          inherit (cfg) polarity;
        })
      ];
    };
  };
}
