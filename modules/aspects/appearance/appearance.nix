{inputs, ...}: {
  flake-file.inputs = {
    wallpapers = {
      url = "git+https://codeberg.org/voidptrx/wallpapers";
      flake = false;
    };

    stylix.url = "github:nix-community/stylix";
  };

  den.aspects.appearance = {
    nixos = {
      pkgs,
      lib,
      config,
      ...
    }: {
      imports = [inputs.stylix.nixosModules.stylix];

      # TODO: Implement as a den class with guard instead
      options.stylix.targetsToDisable = with lib;
        mkOption {
          type = types.listOf types.str;
          default = [];
          example = [
            "fish"
          ];
          description = "List of stylix targets which theming to disable.";
        };

      config.stylix = {
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

        targets = lib.genAttrs config.stylix.targetsToDisable (_: {
          enable = false;
        });
      };
    };

    homeManager = {
      pkgs,
      lib,
      config,
      ...
    }: let
      wallpapersPath = inputs.wallpapers.outPath;
      awwwPkg = pkgs.awww;
      find = lib.getExe' pkgs.findutils "find";
      shuf = lib.getExe' pkgs.coreutils "shuf";

      wallpaperScript = pkgs.writeShellScriptBin "awww-random" ''
        DIR="${wallpapersPath}"
        img=$( ${find} "$DIR" -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.gif" -o -iname "*.webp" -o -iname "*.bmp" \) | ${shuf} -n 1)
        if [ -n "$img" ]; then
          ${lib.getExe awwwPkg} img --transition-fps 144 --transition-type wave --transition-angle 225 --resize=fit "$img"
        fi
      '';
    in {
      options.stylix.targetsToDisable = with lib;
        mkOption {
          type = types.listOf types.str;
          default = [];
          example = [
            "kitty"
            "neovim"
          ];
          description = "List of stylix targets which theming to disable.";
        };

      config.stylix.targets = lib.genAttrs config.stylix.targetsToDisable (_: {
        enable = false;
      });

      config.home.packages = [
        awwwPkg
        wallpaperScript
      ];

      config.systemd.user.services.awww-daemon = {
        Unit = {
          Description = "awww Wallpaper daemon";
          After = ["graphical-session.target"];
          Wants = ["awww-random.timer"];
        };

        Service = {
          ExecStart = "${lib.getExe awwwPkg}";
          Restart = "on-failure";
          RestartSec = 1;
        };

        Install = {
          WantedBy = ["graphical-session.target"];
        };
      };

      config.systemd.user.services.awww-random = {
        Unit = {
          Description = "Wallpaper rotator";
        };

        Service = {
          ExecStart = "${lib.getExe wallpaperScript}";
          Restart = "on-failure";
          RestartSec = 2;

          Type = "oneshot";
        };
      };

      config.systemd.user.timers.awww-random = {
        Unit = {
          Description = "Change wallpaper every 30 minutes";
          BindsTo = ["awww-daemon.service"];
          Wants = ["awww-random.service"];
        };

        Timer = {
          OnUnitActiveSec = "30min";
          AccuracySec = "1s";
        };
      };
    };
  };
}
