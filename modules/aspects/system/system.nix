{ inputs, den, ... }:

{
  flake-file.inputs = {
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  den.aspects.system = {
    nixos = {
      services.displayManager.lemurs = {
        enable = false;
        settings = {
          tty = 1;
          do_log = true;
          focus_behaviour = "password";

          background = {
            show_background = true;
            style = {
              color = "dark gray";
              show_border = true;
              border_color = "orange";
            };
          };

          username_field.remember = true;
          password_field.content_replacement_character = "*";
        };
      };

      services.displayManager.ly = {
        enable = true;
        settings = {
          animation = "matrix";
          animation_frame_delay = 5;

          asterisk = "*";
          blank_box = true;
          hide_borders = false;
          load = true;

          margin_box_h = 2;
          margin_box_v = 4;
          text_in_center = true;
          full_color = true;

          clear_password = true;
          default_input = "password";

          vi_mode = true;
          vi_default_mode = "insert";
          battery_id = "BAT1";
        };
      };

      programs.niri.enable = true;
    };

    homeManager =
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

            binds = import ./_binds.nix { inherit pkgs lib config; };

            layout = {
              gaps = 10;
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
                width = 4;
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
                geometry-corner-radius.top-left = 12.0;
                geometry-corner-radius.top-right = 12.0;
                geometry-corner-radius.bottom-left = 12.0;
                geometry-corner-radius.bottom-right = 12.0;
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
                    app-id = "^(zen-beta|mpv)$";
                  }
                ];
                default-column-width.proportion = 1.0;
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
  };
}
