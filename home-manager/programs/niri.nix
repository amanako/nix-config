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
        noctalia-shell = args: {
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
        "Mod+S" = noctalia-shell [
          "controlCenter"
          "toggle"
        ];
        "Mod+Comma" = noctalia-shell [
          "settings"
          "toggle"
        ];
        "Mod+N" = noctalia-shell [
          "notifications"
          "toggle"
        ];
        "Mod+Space" = noctalia-shell [
          "launcher"
          "toggle"
        ];
        "Mod+V" = noctalia-shell [
          "clipboard"
          "toggle"
        ];
        "XF86AudioLowerVolume" = noctalia-shell [
          "volume"
          "decreease"
       ];
        "XF86AudioRaiseVolume" = noctalia-shell [
          "volume"
	  "increase"
	];
        "XF86AudioMute" = noctalia-shell [
          "volume"
          "muteOutput"
        ];
        "XF86MonBrightnessDown" = noctalia-shell [
          "brightness"
          "decrease"
        ];
        "XF86MonBrightnessUp" = noctalia-shell [
          "brightness"
          "increase"
        ];

        # Niri-specific config starts here
        "Mod+0".action.focus-workspace = 10;
        "Mod+1".action.focus-workspace = 1;
        "Mod+2".action.focus-workspace = 2;
        "Mod+3".action.focus-workspace = 3;
        "Mod+4".action.focus-workspace = 4;
        "Mod+5".action.focus-workspace = 5;
        "Mod+6".action.focus-workspace = 6;
        "Mod+7".action.focus-workspace = 7;
        "Mod+8".action.focus-workspace = 8;
        "Mod+9".action.focus-workspace = 9;

        "Mod+BracketLeft".action.consume-or-expel-window-left = [ ];
        "Mod+BracketRight".action.consume-or-expel-window-right = [ ];
        "Mod+C".action.center-column = [ ];
        "Mod+F".action.maximize-column = [ ];
        "Mod+H".action.focus-column-left = [ ];
        "Mod+J".action.focus-window-or-workspace-down = [ ];
        "Mod+K".action.focus-window-or-workspace-up = [ ];
        "Mod+L".action.focus-column-right = [ ];
	"Mod+Tab".action.toggle-overview = [ ];

	  # Fallback keybind for non-vim users
	"Mod+Left".action.focus-column-left = [ ];
	"Mod+Right".action.focus-column-right = [ ];

        "Mod+R".action.switch-preset-column-width-back = [ ];

        "Mod+T".action.spawn = "kitty";
	"Mod+W".action.spawn = "vivaldi";
	"Mod+Y" = sh "yazi";
        "Mod+Shift+C".action.center-visible-columns = [ ];
        "Mod+Shift+F".action.fullscreen-window = [ ];
        "Mod+Shift+H".action.move-column-left = [ ];
        "Mod+Shift+J".action.move-column-to-workspace-down = [ ];
        "Mod+Shift+K".action.move-column-to-workspace-up = [ ];
        "Mod+Shift+L".action.move-column-right = [ ];
        "Mod+Shift+R".action.switch-preset-column-width = [ ];

        "Mod+Q".action.close-window = [ ]; 
        "Print".action.screenshot = [ ];
      };
    };
  };
}
