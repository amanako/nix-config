{ inputs, ... }:

{
  flake-file.inputs = {
    awww.url = "git+https://codeberg.org/LGFae/awww";
    wallpapers = {
      url = "git+https://codeberg.org/voidptrx/wallpapers";
      flake = false;
    };

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
      let
        awwwPackage = inputs.awww.packages.${pkgs.stdenv.hostPlatform.system}.awww;
        wallpapersPath = inputs.wallpapers.outPath;

        wallpaperScript = pkgs.writeShellScriptBin "awww-random" ''
          DIR="${wallpapersPath}"
          INTERVAL=1800

          while true; do
            img=$( ${pkgs.findutils}/bin/find "$DIR" -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.gif" -o -iname "*.webp" -o -iname "*.bmp" \) | ${pkgs.coreutils}/bin/shuf -n 1)
            
          if [ -n "$img" ]; then
            ${awwwPackage}/bin/awww img --transition-fps 144 --transition-type wave --transition-angle 225 --resize=fit "$img"
          fi
            
          ${pkgs.coreutils}/bin/sleep "$INTERVAL"
          done
        '';
      in
      with lib;
      {
        imports = [ inputs.stylix.homeModules.stylix ];

        config.home.packages = [
          awwwPackage
          wallpaperScript
        ];

        config.systemd.user.services.awww-daemon = {
          Unit = {
            Description = "AWWW Wallpaper daemon";
            After = [ "graphical-session.target" ];
          };

          Service = {
            ExecStart = "${awwwPackage}/bin/awww-daemon";
            Restart = "on-failure";
            RestartSec = 5;
          };

          Install = {
            WantedBy = [ "graphical-session.target" ];
          };
        };

        config.systemd.user.services.awww-random = {
          Unit = {
            Description = "Wallpaper rotator";
            After = [ "awww-daemon.service" ];
            Wants = [ "awww-daemon.service" ];
          };

          Service = {
            ExecStart = "${wallpaperScript}/bin/awww-random";
            Restart = "on-failure";
            RestartSec = 2;
            Environment = "WAYLAND_DISPLAY=wayland-1";
          };

          Install = {
            WantedBy = [ "default.target" ];
          };
        };

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
          base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-soft.yaml";
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
