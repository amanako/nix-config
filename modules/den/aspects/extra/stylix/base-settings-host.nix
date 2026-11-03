{lib, ...}: let
  inherit
    (lib)
    mkOption
    types
    ;
in {
  den.aspects.extra.stylix-host.base-settings = {
    description = "Base stylix theming defaults for hosts: theme, fonts, and icon pack.";

    hostSettings = {
      theme = mkOption {
        type = types.str;
        default = "gruvbox-material-dark-soft";
        example = "catppuccin-mocha";
        description = "Base16 scheme slug from `pkgs.base16-schemes` used for system-wide Stylix theming.";
      };

      icons = mkOption {
        type = types.submodule {
          options = {
            package = mkOption {
              type = types.functionTo types.package;
              example = lib.literalExpression "pkgs: pkgs.kdePackages.breeze-icons";
              description = ''
                Function taking nixpkgs and returning the icon theme package.
              '';
            };

            dark = mkOption {
              type = types.str;
              description = "Dark icon theme name.";
            };

            light = mkOption {
              type = types.str;
              description = "Light icon theme name.";
            };
          };
        };

        default = {
          package = pkgs: pkgs.papirus-icon-theme;
          dark = "Papirus-Dark";
          light = "Papirus-Light";
        };

        defaultText = lib.literalExpression ''
          {
            package = pkgs: pkgs.papirus-icon-theme;
            dark = "Papirus-Dark";
            light = "Papirus-Light";
          }
        '';

        description = ''
          Icon theme configuration. Defaults to Papirus.
        '';
      };
    };

    nixos = {
      pkgs,
      config,
      host,
      ...
    }: let
      cfg = host.settings.extra.stylix-host.base-settings;
      schemePath = pkgs: name: "${pkgs.base16-schemes}/share/themes/${name}.yaml";
      # Each scheme file has a `variant` node ("light" or "dark"), which both stylix
      # and the package variants support, so it maps directly to polarity.
      getPolarityOf = scheme:
        scheme
        |> builtins.readFile
        |> builtins.match ".*variant: \"(light|dark)\".*"
        |> lib.head;
      scheme = schemePath pkgs cfg.theme;
    in {
      stylix = {
        base16Scheme = scheme;
        polarity = getPolarityOf scheme;
        opacity = {
          applications = 0.87;
          desktop = 0.85;
          popups = 0.86;
          terminal = 0.85;
        };

        icons = {
          enable = true;
          package = cfg.icons.package pkgs;
          dark = cfg.icons.dark;
          light = cfg.icons.light;
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
  };
}
