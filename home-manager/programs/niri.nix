{ pkgs, lib, ... }:

{
    programs.niri = {
      enable = true;
      package = pkgs.niri;
      settings = {
	environment = {
          XDG_CURRENT_DESKTOP = "niri";
	  XDG_SESSION_TYPE = "wayland";
	  QT_QPA_PLATFORM = "wayland";
	};

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

	layout = {
          border = {
            enable = true;
	  };
	};

	binds =
        let
          dms = args: {
            action.spawn = [
              "dms"
              "ipc"
              "call"
            ]
            ++ args;
          };
          sh = cmd: { action.spawn-sh = cmd; };
        in
        {
          "Ctrl+Alt+A" = dms [
            "dash"
            "toggle"
            "overview"
          ];
          "Ctrl+Alt+C" = dms [
            "control-center"
            "toggle"
          ];
          "Ctrl+Alt+D" = dms [
            "dash"
            "toggle"
            "media"
          ];
          "Ctrl+Alt+L" = dms [
            "wallpaper"
            "next"
          ];
          "Ctrl+Alt+S" = dms [
            "powermenu"
            "toggle"
          ];
	  "Mod+Comma" = dms [
            "settings"
	    "toggle"
	  ];
	  "Mod+D" = dms [
	    "welcome"
	    "doctor"
	  ];

	  "Mod+M" = dms [
            "processlist"
            "toggle"
          ];
          "Mod+N" = dms [
            "notifications"
            "toggle"
          ];

	  "Mod+Space" = dms [
            "spotlight"
            "toggle"
          ];
          "Mod+V" = dms [
            "clipboard"
            "toggle"
          ];

          "XF86AudioLowerVolume" =
            sh "wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%-; dms ipc call audio increment 0";
          "XF86AudioMute" = dms [
            "audio"
            "mute"
          ];
          "XF86AudioPlay" = dms [
            "mpris"
            "playPause"
          ];
          "XF86AudioRaiseVolume" =
            sh "wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+; dms ipc call audio increment 0";
          "XF86MonBrightnessDown" = dms [
            "brightness"
            "decrement"
            "5"
            ""
          ];
          "XF86MonBrightnessUp" = dms [
            "brightness"
            "increment"
            "5"
            ""
          ];




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

          
          "Mod+P" = sh "wl-mirror $(niri msg --json focused-output | jq -r .name)";
          "Mod+R".action.switch-preset-column-width-back = [ ];

          "Mod+T".action.spawn = "kitty";
	  "Mod+W".action.spawn = "vivaldi";
	  "Mod+Y" = sh "kitty yazi";
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
