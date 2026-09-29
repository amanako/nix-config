{
  den,
  lib,
  noctalia,
  ...
}: {
  den.aspects.everyday.bars.waybar = {
    description = "Highly customizable Wayland bar for wlroots-based compositors.";

    includes = [
      den.aspects.everyday.bars.waybar.style
      den.aspects.everyday.bars.conflict-manager
    ];

    stylixHMSettings.targets."waybar".enable = false;

    userSettings = {
      location = lib.mkOption {
        type = lib.types.str;
        example = "London, UK";
        description = "Location passed to wttrbar for the weather module.";
      };
    };

    hm = {
      lib,
      user,
      pkgs,
      ...
    }: let
      # Launch a TUI inside the user's terminal emulator.
      inherit (user.preferences.effective) term;
      termCmd = cmd: "${term} -e ${cmd}";
    in {
      services.playerctld.enable = !user.hasAspect noctalia.entry;

      programs.waybar = {
        enable = true;

        systemd = {
          enable = true;
          targets = ["graphical-session.target"];
          enableDebug = true;
        };

        settings = {
          mainBar =
            {
              reload_style_on_change = true;

              name = "main";
              id = "main";
              layer = "top";
              position = "top";
              exclusive = true;
              spacing = 10;

              margin-left = 20;
              margin-right = 20;
              on-scroll-up = "";
              on-scroll-down = "";

              modules-left =
                [
                  "niri/workspaces"
                  "idle_inhibitor"
                  "tray"
                  "battery"
                ]
                ++ lib.optional (!user.hasAspect noctalia.entry) "mpris";

              modules-center = [
                "clock"
                "custom/weather"
              ];

              modules-right = [
                "pulseaudio"
                "bluetooth"
                "network"
                "power-profiles-daemon"
                "backlight"
                "memory"
                "cpu"
              ];

              "niri/workspaces" = {
                disable-scroll = true;
                all-outputs = true;
                format = "{icon}";
                format-icons = {
                  "1" = "一";
                  "2" = "二";
                  "3" = "三";
                  "4" = "四";
                  "5" = "五";
                  "6" = "六";
                  "7" = "七";
                  "8" = "八";
                  "9" = "九";
                  "10" = "十";
                  default = "◉";
                };
                persistent-workspaces = {
                  "*" = 3;
                };
              };

              "custom/weather" = let
                cfg = user.settings.everyday.bars.waybar;
              in {
                format = "{}°";
                tooltip = true;
                interval = 3600;
                exec = "${pkgs.wttrbar |> lib.getExe} --nerd --location '${cfg.location}' || echo '{\"text\":\"\",\"tooltip\":\"weather unavailable\"}'";
                return-type = "json";
              };

              "clock" = {
                format = "{:%H:%M}";
                tooltip-format = "{:%A, %F}\n{calendar}";
                calendar = {
                  mode = "month";
                  weeks-pos = "left";
                  iso8601 = true;
                };
                on-scroll-up = "shift_up";
                on-scroll-down = "shift_down";
                interval = 60;
              };

              "cpu" = {
                interval = 5;
                format = " {usage}%";
                tooltip = true;
                tooltip-format = "CPU: {usage}%";
                on-click = termCmd (pkgs.btop |> lib.getExe);
                states = {
                  warning = 60;
                  critical = 90;
                };
              };

              "memory" = {
                interval = 5;
                format = " {percentage}%";
                tooltip = true;
                tooltip-format = "{used:0.1f}GB/{total:0.1f}GB\n{swapState}:{swapUsed:0.1f}/{swapTotal:0.1f}";
              };

              "backlight" = {
                format = "{icon}";
                tooltip = true;
                tooltip-format = "Brightness:  {percent}%";
                format-alt = "{percent}% {icon}";
                format-alt-click = "click-right";
                format-icons = ["󰃜" "󰃝" "󰃞" "󰃟" "󰃠"];
                on-scroll-down = "${pkgs.brightnessctl |> lib.getExe} s 5%-";
                on-scroll-up = "${pkgs.brightnessctl |> lib.getExe} s +5%";
              };

              "battery" = {
                format = "{icon}";
                format-discharging = "{capacity}% {icon}";
                format-charging = "{capacity}% {icon}";
                format-plugged = "";
                format-icons = {
                  charging = ["󰢜" "󰂆" "󰂇" "󰂈" "󰢝" "󰂉" "󰢞" "󰂊" "󰂋" "󰂅"];
                  default = ["󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
                };
                format-full = "󰂅";
                format-time = "{H}h {m}m";
                tooltip-format-discharging = "Empty in {time}";
                tooltip-format-charging = "Full in {time}";
                interval = 5;
                states = {
                  warning = 20;
                  critical = 10;
                };
              };

              "pulseaudio" = {
                format = "{icon}";
                format-muted = "󰖁";
                format-icons = {
                  default = ["󰕿" "󰖀" "󰕾"];
                  headset = "󰋋";
                };
                states = {
                  critical = 0;
                };
                tooltip = true;
                tooltip-format = "{desc}\nVolume: {volume}%";
                scroll-step = 5;
                max-volume = 100;
                on-click = termCmd (pkgs.ncpamixer |> lib.getExe);
                on-click-right = "${"wpctl" |> lib.getExe' pkgs.wireplumber} set-mute @DEFAULT_AUDIO_SINK@ toggle";
              };

              "bluetooth" = {
                format = " {num_connections}";
                format-disabled = "󰂲 {status}";
                format-connected = "󰂱 {num_connections}";
                tooltip-format = "Devices connected: {num_connections}";
                on-click = termCmd (pkgs.bluetui |> lib.getExe);
              };

              "network" = {
                format-icons = [
                  "󰤯"
                  "󰤟"
                  "󰤢"
                  "󰤥"
                  "󰤨"
                ];
                format = "{icon}";
                format-wifi = "{icon}";
                format-ethernet = "󰈀";
                format-disconnected = "󰤮";
                tooltip-format-wifi = "{essid} ({frequency} GHz)\n⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}";
                tooltip-format-ethernet = "⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}";
                tooltip-format-disconnected = "Disconnected";
                interval = 3;
                spacing = 1;
                justify = "center";
                on-click = termCmd (pkgs.wifitui |> lib.getExe);
              };

              "idle_inhibitor" = {
                format = "{icon}";
                tooltip-format-activated = "Stay Awake: ON 󱎴";
                tooltip-format-deactivated = "Stay Awake: OFF 󰶐";
                format-icons = {
                  activated = "󱎴";
                  deactivated = "󰷛";
                };
              };

              "tray" = {
                icon-size = 13;
                spacing = 2;
              };

              "power-profiles-daemon" = {
                format = "{icon}";
                tooltip-format = "Power profile: {profile}\nDriver: {driver}";
                format-icons = {
                  performance = "";
                  balanced = " ";
                  power-saver = "󰁳";
                };
              };
              # The MPRIS module is gated on NOT having the noctalia desktop-shell aspect.
              # noctalia registers its own `dev.noctalia.Mpris` D-Bus service that does not
              # implement the standard `org.mpris.MediaPlayer2.*` interface, so it monopolizes
              # the bus and starves playerctl / waybar's stock mpris module (which only see
              # standard MPRIS players). When noctalia is active, media is surfaced by noctalia
              # itself; this module is therefore omitted to avoid a permanently-empty slot.
            }
            // lib.optionalAttrs (!user.hasAspect noctalia.entry) {
              "mpris" = {
                format = "  {dynamic}";
                format-paused = " {status_icon} {dynamic}";
                interval = 1;
                dynamic-order = ["artist" "position" "length"];
                dynamic-importance-order = ["position" "length" "artist"];
                tooltip-format = "{player} ({status}):\n{artist} - {title}";
                status-icons = {
                  paused = "󰝛";
                };
              };
            };
        };
      };
    };
  };
}
