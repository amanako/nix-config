{ pkgs, ... }:

{
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

      spawn-at-startup = [
	{
          command = [ "noctalia-shell" ];
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

      binds =
      let
        noctalia = args: {
          action.spawn = [
            "noctalia-shell"
            "ipc"
            "call"
          ]
          ++ args;
        };
        sh = cmd: { action.spawn-sh = cmd; };
      in
      {
        "Mod+S" = noctalia [
          "controlCenter"
          "toggle"
        ];
        "Mod+Comma" = noctalia [
          "settings"
          "toggle"
        ];
        "Mod+Space" = noctalia [
          "launcher"
          "toggle"
        ];
        "XF86AudioLowerVolume" = noctalia [
          "volume"
          "decreease"
       ];
        "XF86AudioRaiseVolume" = noctalia [
          "volume"
	  "increase"
	];
        "XF86AudioMute" = noctalia [
          "volume"
          "muteOutput"
        ];
        "XF86MonBrightnessDown" = noctalia [
          "brightness"
          "decrease"
        ];
        "XF86MonBrightnessUp" = noctalia [
          "brightness"
          "increase"
        ];

        # Niri-specific config starts here
        "Mod+1".action.focus-workspace = 1;
        "Mod+2".action.focus-workspace = 2;
        "Mod+3".action.focus-workspace = 3;
        "Mod+4".action.focus-workspace = 4;
        "Mod+5".action.focus-workspace = 5;
        "Mod+6".action.focus-workspace = 6;
        "Mod+7".action.focus-workspace = 7;
        "Mod+8".action.focus-workspace = 8;
        "Mod+9".action.focus-workspace = 9;

        "Mod+Ctrl+1".action.move-column-to-workspace = 1;
        "Mod+Ctrl+2".action.move-column-to-workspace = 2;
        "Mod+Ctrl+3".action.move-column-to-workspace = 3;
        "Mod+Ctrl+4".action.move-column-to-workspace = 4;
        "Mod+Ctrl+5".action.move-column-to-workspace = 5;
        "Mod+Ctrl+6".action.move-column-to-workspace = 6;
        "Mod+Ctrl+7".action.move-column-to-workspace = 7;
        "Mod+Ctrl+8".action.move-column-to-workspace = 8;
        "Mod+Ctrl+9".action.move-column-to-workspace = 9;

        "Mod+BracketLeft".action.consume-or-expel-window-left = [ ];
        "Mod+BracketRight".action.consume-or-expel-window-right = [ ];
        "Mod+C".action.center-column = [ ];
	"Mod+Ctrl+C".action.center-visible-columns = [ ];
        "Mod+F".action.maximize-column = [ ];
	"Mod+M".action.maximize-window-to-edges = [ ];

        "Mod+K".action.focus-window-or-workspace-up = [ ];
        "Mod+J".action.focus-window-or-workspace-down = [ ];
        "Mod+H".action.focus-column-left = [ ];
        "Mod+L".action.focus-column-right = [ ];

	"Mod+Up".action.focus-window-or-workspace-up = [ ];
	"Mod+Down".action.focus-window-or-workspace-down = [ ];
	"Mod+Left".action.focus-column-left = [ ];
	"Mod+Right".action.focus-column-right = [ ];

        "Mod+R".action.switch-preset-column-width-back = [ ];
	"Mod+Tab".action.toggle-overview = [ ];

        "Mod+T".action.spawn = "kitty";
	"Mod+W".action.spawn = "vivaldi";
	"Mod+Y" = sh "kitty -e yazi";
	"Mod+N" = sh "kitty -e nvim";

        "Mod+Shift+C".action.center-visible-columns = [ ];
        "Mod+Shift+F".action.fullscreen-window = [ ];
        "Mod+Shift+H".action.move-column-left = [ ];
        "Mod+Shift+J".action.move-column-to-workspace-down = [ ];
        "Mod+Shift+K".action.move-column-to-workspace-up = [ ];
        "Mod+Shift+L".action.move-column-right = [ ];
        "Mod+Shift+R".action.switch-preset-column-width = [ ];

	"Mod+Home".action.focus-column-first = [ ];
	"Mod+End".action.focus-column-last = [ ];
        "Mod+Ctrl+Home".action.move-column-to-first = [ ];
        "Mod+Ctrl+End".action.move-column-to-last = [ ];

	"Mod+Shift+E".action.quit = [ ];
	"Mod+Shift+Slash".action.show-hotkey-overlay = [ ];

	"Mod+V".action.toggle-window-floating = [ ];
	"Mod+Shift+V".action.switch-focus-between-floating-and-tiling = [ ];

        "Print".action.screenshot = [ ];
	"Ctrl+Print".action.screenshot-screen = [ ];
	"Alt+Print".action.screenshot-window = [ ];

        "Mod+Shift+P".action.power-off-monitors = [ ];
	"Mod+Q".action.close-window = [ ]; 
      };
    };
  };
}
