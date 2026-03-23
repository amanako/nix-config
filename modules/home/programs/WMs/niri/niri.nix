{ inputs, ... }:

{
  flake.hmModules.niri =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      imports = [ inputs.niri.homeModules.niri ];

      # TODO: make this option auto-import noctalia or dms inputs.self.hmModules.shell
      options.programs.niri.autoSpawnShell =
        with lib;
        mkOption {
          type = types.enum [
            "none"
            "noctalia"
            "dms"
          ];
          default = "none";
          example = "noctalia";
          description = "Which shell to automatically spawn when starting niri.";
        };

      # TODO: Watch out if this works | You changed home.file in dms.nix
      config.home.activation.regenerateNiriConfig =
        lib.mkIf (config.programs.niri.autoSpawnShell != "none")
          (
            lib.hm.dag.entryBefore [ "writeBoundary" ] ''
              rm -rf ${config.home.homeDirectory}/.config/niri
            ''
          );

      config.programs.niri = {
        enable = true;
        # Pin latest nixpkgs version - required for dms and noctalia
        package = pkgs.niri;
        settings = {
          # Important variables to initialize wayland - will likely crash otherwise
          environment = {
            XDG_CURRENT_DESKTOP = "niri";
            XDG_SESSION_TYPE = "wayland";
            QT_QPA_PLATFORM = "wayland";
            QT_QPA_PLATFORMTHEME = "qt6ct";
          };

          # For compatibility with various X11-based programs while running niri
          xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;

          binds = import ./_binds.nix { inherit config; };

          layout = {
            gaps = 2;
            background-color = "transparent";
            center-focused-column = "never";
            default-column-width.proportion = 0.5;
            preset-column-widths = [
              {
                proportion = 0.333333;
              }
              {
                proportion = 0.5;
              }
              {
                proportion = 0.666667;
              }
            ];

            focus-ring = {
              width = 2;
              active.color = lib.mkIf config.programs.starship.enable (
                config.programs.starship.settings.palettes.gruvbox_dark.color_main
              );
            };

            border = {
              enable = false;
              width = 2;
            };

            shadow = {
              softness = 30;
              spread = 5;
              offset.x = 0;
              offset.y = 5;
            };
          };

          window-rules = [
            {
              geometry-corner-radius.top-left = 10.0;
              geometry-corner-radius.top-right = 10.0;
              geometry-corner-radius.bottom-left = 10.0;
              geometry-corner-radius.bottom-right = 10.0;
              clip-to-geometry = true;
              tiled-state = true;
              draw-border-with-background = false;
            }
            {
              # Last one is ProtonUp-Qt
              matches = [
                {
                  app-id = "^(org.quickshell|nvidia-settings|net.davidotek.pupgui2)$";
                }
              ];
              open-floating = true;
              default-column-width.proportion = 0.5;
              default-window-height.proportion = 0.9;
            }
            {
              matches = [
                {
                  app-id = "zen-beta";
                }
              ];
              default-column-width.proportion = 1.0;
            }
          ];

          layer-rules = [
            {
              matches = [
                {
                  namespace = "^quickshell$";
                }
              ];
              place-within-backdrop = true;
            }
          ];

          overview.workspace-shadow.enable = false;

          # csd = client side decoration
          # Windows will be rectangular and omit csd
          prefer-no-csd = true;

          animations = {
            workspace-switch.kind.spring = {
              damping-ratio = 0.8;
              stiffness = 523;
              epsilon = 0.0001;
            };

            horizontal-view-movement.kind.spring = {
              damping-ratio = 0.85;
              stiffness = 423;
              epsilon = 0.0001;
            };
          };

          debug = {
            honor-xdg-activation-with-invalid-serial = true;
          };

          animations.slowdown = 1.5;
          hotkey-overlay.skip-at-startup = true;

          input = {
            touchpad = {
              tap = true;
              dwt = true;
              natural-scroll = true;
              accel-speed = 0.1;
              accel-profile = "adaptive";
            };

            mouse = {
              accel-speed = -0.5;
            };

            warp-mouse-to-focus.enable = true;
            workspace-auto-back-and-forth = true;

            mod-key = "Super";
            mod-key-nested = "Alt";
          };
        };
      };
    };
}
