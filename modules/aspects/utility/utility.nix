{ inputs, ... }:
{
  flake-file.inputs = {
    nix-index-database.url = "github:nix-community/nix-index-database";
  };

  den.aspects.utility = {
    nixos = {
      programs.localsend = {
        enable = true;
        openFirewall = true;
      };
    };

    homeManager =
      {
        pkgs,
        lib,
        ...
      }:
      {
        home.sessionVariables = {
          GTK_IM_MODULE = "fcitx";
          QT_IM_MODULE = "fcitx";
        };

        i18n.inputMethod = {
          enable = true;
          type = "fcitx5";

          # Supress some warnings
          fcitx5.waylandFrontend = true;

          fcitx5.addons = with pkgs; [
            # Japanese IM
            fcitx5-mozc-ut
            fcitx5-gtk
          ];
        };

        imports = [ inputs.nix-index-database.homeModules.default ];

        programs.nix-index-database = {
          comma.enable = true;
        };

        programs.mpv = {
          enable = true;
          bindings = {
            "h" = "seek -5";
            "l" = "seek 5";
          };
        };

        programs.jq.enable = true;

        programs.zathura = {
          enable = true;
          options = {
            # Evade blinding
            recolor = true;
            recolor-lightcolor = lib.mkDefault "#1e3a8a";
            recolor-darkcolor = lib.mkDefault "#e0f2fe";

            selection-clipboard = "clipboard";
          };
        };
      };
  };
}
