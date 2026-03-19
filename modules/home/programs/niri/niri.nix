{ inputs, ... }:

{
  # TODO: Use config.lib.mkOutOfSymlink for auto-reload
  flake.hmModules.niri =
    {
      pkgs,
      config,
      ...
    }:
    {
      imports = [ inputs.niri.homeModules.niri ];

      # For compatibility with various X11-based programs while running niri
      home.packages = [
        pkgs.xwayland-satellite
      ];

      programs.niri = {
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

          binds = import ./_binds.nix { inherit config; };

          layout = {
            gaps = 2;
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
              active.color = "#98971a";
            };

            # border.width = 0;
          };

          #window-rules = {
          #  geometry-corner-radius = 20;
          #  clip-to-geometry = true;
          #};

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
