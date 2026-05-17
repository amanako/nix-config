{
  lib,
  inputs,
  den,
  ...
}: let
  stylixNixOSClass = den.batteries.forward {
    each = lib.singleton true;
    fromClass = _: "stylix";
    intoClass = _: "nixos";
    intoPath = _: ["stylix"];
    guard = {options, ...}: options ? stylix;
  };
in {
  flake-file.inputs.stylix.url = "github:nix-community/stylix";

  den.schema.host.options.enableStyling =
    (lib.mkEnableOption "")
    // {
      default = true;
      description = "Whether to enable auto-theming of applications via stylix - theming framework for NixOS: https://github.com/nix-community/stylix";
      example = false;
    };

  den.schema.host.includes = [den.aspects.stylix];

  den.aspects.stylix = {host, ...}:
    lib.optionalAttrs host.enableStyling {
      includes = [stylixNixOSClass];

      nixos = {
        pkgs,
        config,
        ...
      }: {
        # Automatically enables stylix for home manager if detected
        imports = [inputs.stylix.nixosModules.stylix];
        stylix = {
          enable = true;
          base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-soft.yaml";
          polarity = "dark";
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
            monospace = {
              package = pkgs.nerd-fonts.victor-mono;
              name = "VictorMono Nerd Font";
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
        };
      };
    };
}
