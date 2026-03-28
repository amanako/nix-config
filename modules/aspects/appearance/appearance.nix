{ inputs, ... }:

{
  flake-file.inputs = {
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  den.aspects.appearance = {
    homeManager =
      {
        pkgs,
        lib,
        config,
        ...
      }:

      with lib;
      {
        imports = [ inputs.stylix.homeModules.stylix ];

        options.stylix.targetsToDisable = mkOption {
          type = types.listOf types.str;
          default = [ ];
          example = [
            "kitty"
            "neovim"
          ];
          description = "List of stylix targets which theming to disable.";
        };

        config.stylix = {
          enable = true;
          base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-medium.yaml";
          polarity = "dark";

          icons = {
            enable = true;
            package = pkgs.papirus-icon-theme;

            dark = "Papirus-Dark";
            light = "Papirus-Light";
          };

          fonts = {
            monospace = {
              package = pkgs.nerd-fonts.victor-mono;
              name = "Victor Mono Nerd Font";
            };
            sansSerif = {
              package = pkgs.inter;
              name = "Inter";
            };
            # Serif fonts can be bothersome
            serif = config.stylix.fonts.sansSerif;
            emoji = {
              package = pkgs.twemoji-color-font;
              name = "Twemoji";
            };
          };

          targets = genAttrs config.stylix.targetsToDisable (_: {
            enable = false;
          });
        };
      };
  };
}
