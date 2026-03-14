{ inputs, pkgs, ... }:

{
  imports = [ inputs.niri.homeModules.niri ];

	home.packages = with pkgs; [
		xwayland-satellite
	];

  programs.niri = {
    enable = true;
    package = pkgs.niri;
    settings = {
      environment = {
        XDG_CURRENT_DESKTOP = "niri";
				XDG_SESSION_TYPE = "wayland";
        QT_QPA_PLATFORM = "wayland";
				QT_QPA_PLATFORMTHEME = "qt6ct";
      };

      layout = {
				gaps = 2;
				default-column-width.proportion = 0.5;
				preset-column-widths = [
					{
						proportion = 0.33333;
					}
					{
					  proportion = 0.5;
					}
					{
						proportion = 0.66667;
					}
				];

				focus-ring = {
          width = 2;
					active.color = "#98971a";
				};

				border.width = 0;
      };

			animations.slowdown = 1.5;
			hotkey-overlay.skip-at-startup = true;

      spawn-at-startup = [
				{
          command = [ "noctalia-shell" ];
				}
				{
					command = [ "fcitx5" ];
				}
      ];

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
}
