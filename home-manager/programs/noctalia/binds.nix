{
  programs.niri.settings.binds = 
      let
        noctalia = args: {
          action.spawn = [
            "noctalia-shell"
            "ipc"
            "call"
          ]
          ++ args;
        };
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
	"Mod+Alt+C" = noctalia [
          "plugin:clipper"
	  "toggle"
	];
        "Mod+Space" = noctalia [
          "launcher"
          "toggle"
        ];
	"Mod+Shift+N" = noctalia [
          "notifications"
	  "toggleHistory"
	];
        "Ctrl+K" = noctalia [
	  "plugin:keybind-cheatsheet"
	  "toggle"
	];
	"Alt+Shift+C" = noctalia [
	  "calendar"
	  "toggle"
	];
        "XF86AudioLowerVolume" = noctalia [
          "volume"
          "decrease"
        ];
        "XF86AudioRaiseVolume" = noctalia [
          "volume"
	  "increase"
	];
	"Mod+Alt+V" = noctalia [
          "volume"
	  "togglePanel"
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
	"Mod+A" = noctalia [
	  "idleInhibitor"
	  "toggle"
	];
	"Alt+Shift+L" = noctalia [
          "lockScreen"
	  "lock"
	];
	"Alt+Shift+M" = noctalia [
          "sessionMenu"
	  "toggle"
	];
      };
}
