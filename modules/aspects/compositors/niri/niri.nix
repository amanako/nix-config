{
  inputs,
  den,
  ...
}: {
  flake-file = {
    inputs = {
      niri.url = "github:sodiboo/niri-flake";
    };

    nixConfig = {
      extra-substituters = ["https://niri.cachix.org"];
      extra-trusted-public-keys = ["niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="];
    };
  };

  den.aspects.compositors.provides.niri = {
    provides.binds = den.aspects.niri-binds;

    nixos = {pkgs, ...}: {
      systemd.user.services.niri-flake-polkit.enable = false;
      nixpkgs.overlays = [inputs.niri.overlays.niri];
      # Necessary for niri to be enabled globally and then enabled per-user
      # This helps since it can be caught by display managers
      # We also want to match nixos and home-manager versions
      programs.niri = {
        enable = true;
        package = pkgs.niri-unstable;
      };
    };

    homeManager = {
      pkgs,
      lib,
      config,
      ...
    }: {
      imports = [inputs.niri.homeModules.niri];

      options.programs.niri.autoSpawnShell = with lib;
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

      # Notification daemon to run as standalone niri
      config.services.dunst = lib.mkIf (config.programs.niri.autoSpawnShell == "none") {
        enable = true;
        settings = {
          global = {
            width = 300;
            height = 300;
            offset = "30x50";
            origin = "top-right";
            transparency = 10;
            frame_color = "#eceff1";
          };

          urgency_normal = {
            background = "#37474f";
            foreground = "#eceff1";
            timeout = 10;
          };
        };
      };

      config.nixpkgs.overlays = [inputs.niri.overlays.niri];

      config.programs.niri = {
        enable = true;
        package = pkgs.niri-unstable;
        # Reference: https://github.com/sodiboo/niri-flake/blob/main/docs.md#programsnirisettings
        settings = {
          # Important variables to initialize wayland - will likely crash otherwise
          environment = {
            XDG_CURRENT_DESKTOP = "niri";
            XDG_SESSION_TYPE = "wayland";
            QT_QPA_PLATFORM = "wayland";
            QT_QPA_PLATFORMTHEME = "qt6ct";
          };

          workspaces = {
            "dev" = {};
            "gaming" = {};
          };

          # For compatibility with various X11-based programs while running niri
          xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite-unstable;

          layout = {
            gaps = 6;
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
                  app-id = "^(org.quickshell|nvidia-settings|thunar|net.davidotek.pupgui2)$";
                }
              ];
              open-floating = true;
              default-column-width.proportion = 0.5;
              default-window-height.proportion = 0.9;
            }
            {
              matches = [
                {
                  app-id = "^(zen-twilight|mpv)$";
                }
              ];
              default-column-width.proportion = 1.0;
            }
          ];

          overview.workspace-shadow.enable = false;

          # csd = client side decoration
          # Windows will be rectangular and omit csd
          prefer-no-csd = true;

          # Don't show keys at startup
          hotkey-overlay.skip-at-startup = true;

          input = {
            keyboard.track-layout = "window";

            touchpad = {
              dwt = true;
              accel-speed = 0.1;
              accel-profile = "adaptive";
              scroll-method = "two-finger";
            };

            mouse = {
              accel-speed = -0.5;
            };

            warp-mouse-to-focus.enable = true;
            workspace-auto-back-and-forth = true;

            mod-key = "Super";
            mod-key-nested = "Alt";
          };

          cursor = {
            hide-after-inactive-ms = 3000;
            hide-when-typing = true;
            size = 36;
          };

          animations = {
            slowdown = 1.5;

            window-open = {
              kind.easing = {
                curve = "cubic-bezier";
                curve-args = [
                  0.22
                  1.0
                  0.36
                  1.0
                ];
                duration-ms = 260;
              };

              custom-shader = ''
                vec4 open_color(vec3 coords_geo, vec3 size_geo) {
                    float p = niri_clamped_progress;

                    float slide_px = (1.0 - p) * 60.0;
                    float slide_geo = slide_px / max(size_geo.x, 1.0);

                    float scale = 0.985 + 0.015 * p;

                    vec2 uv = coords_geo.xy;
                    uv -= vec2(0.5, 0.5);
                    uv /= scale;
                    uv += vec2(0.5, 0.5);

                    uv.y -= slide_geo;

                    vec3 coords_tex = niri_geo_to_tex * vec3(uv, 1.0);
                    vec4 color = texture2D(niri_tex, coords_tex.st);

                    color *= p;
                    return color;
                }
              '';
            };

            window-close = {
              kind.easing = {
                curve = "cubic-bezier";
                curve-args = [
                  0.32
                  0.0
                  0.67
                  0.0
                ];
                duration-ms = 180;
              };

              custom-shader = ''
                vec4 close_color(vec3 coords_geo, vec3 size_geo) {
                    float p = niri_clamped_progress;
                    float inv = 1.0 - p;

                    float slide_px = p * 40.0;
                    float slide_geo = slide_px / max(size_geo.x, 1.0);

                    float scale = 1.0 - 0.012 * p;

                    vec2 uv = coords_geo.xy;
                    uv -= vec2(0.5, 0.5);
                    uv /= scale;
                    uv += vec2(0.5, 0.5);

                    uv.y -= slide_geo;

                    vec3 coords_tex = niri_geo_to_tex * vec3(uv, 1.0);
                    vec4 color = texture2D(niri_tex, coords_tex.st);

                    color *= inv;
                    return color;
                }
              '';
            };

            window-resize = {
              kind.spring = {
                damping-ratio = 1.0;
                stiffness = 720;
                epsilon = 0.0001;
              };

              custom-shader = ''
                vec4 resize_color(vec3 coords_curr_geo, vec3 size_curr_geo) {
                    vec3 coords_tex_next = niri_geo_to_tex_next * coords_curr_geo;
                    vec4 color = texture2D(niri_tex_next, coords_tex_next.st);

                    vec2 uv = coords_curr_geo.xy;
                    float edge =
                        min(min(uv.x, 1.0 - uv.x), min(uv.y, 1.0 - uv.y));

                    float vignette = smoothstep(0.0, 0.06, edge);
                    color.rgb *= mix(0.985, 1.0, vignette);

                    return color;
                }
              '';
            };

            workspace-switch = {
              kind.spring = {
                damping-ratio = 1.0;
                stiffness = 760;
                epsilon = 0.0001;
              };
            };

            horizontal-view-movement = {
              kind.spring = {
                damping-ratio = 1.0;
                stiffness = 640;
                epsilon = 0.0001;
              };
            };

            window-movement = {
              kind.spring = {
                damping-ratio = 1.0;
                stiffness = 700;
                epsilon = 0.0001;
              };
            };

            config-notification-open-close = {
              kind.spring = {
                damping-ratio = 1.0;
                stiffness = 820;
                epsilon = 0.001;
              };
            };

            exit-confirmation-open-close = {
              kind.spring = {
                damping-ratio = 1.0;
                stiffness = 560;
                epsilon = 0.01;
              };
            };

            screenshot-ui-open = {
              kind.easing = {
                curve = "cubic-bezier";
                curve-args = [
                  0.22
                  1.0
                  0.36
                  1.0
                ];
                duration-ms = 220;
              };
            };

            overview-open-close = {
              kind.spring = {
                damping-ratio = 1.0;
                stiffness = 620;
                epsilon = 0.0001;
              };
            };
          };
        };
      };
    };
  };
}
