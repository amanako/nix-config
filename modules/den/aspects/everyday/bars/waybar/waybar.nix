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
    ];

    stylixHMSettings.targets."waybar".enable = false;

    userConflicts.warnings = [
      ({
        user,
        lib,
        ...
      }: let
        shellBars = [
          den.ful.noctalia.bar
          den.ful.noctalia-shell.bar
          den.ful.dms.bar
        ];
        active = shellBars |> lib.filter (bar: user.hasAspect bar);
      in
        lib.optional (active != []) {
          subject = ["everyday.bars.waybar"];
          target = active |> map (asp: asp.meta.name);
          message = ''
            everyday.bars.waybar: a desktop-shell bar is also active (${active |> map (asp: asp.meta.name) |> lib.concatStringsSep "\n"}).
            Running multiple top-layer bars is likely unintended; remove all but one choice if you did not intend to stack them.
          '';
        })
    ];

    userSettings = {
      location = lib.mkOption {
        type = lib.types.str;
        default = "New York, United States of America";
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
      termCmd = cmd: "${user.preferences.term} -e ${cmd}";
    in {
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
              position = "left";
              exclusive = true;
              height = 800;
              spacing = 10;

              margin-top = 20;
              margin-bottom = 20;
              on-scroll-up = "";
              on-scroll-down = "";

              modules-left = [
                "niri/workspaces"
                "idle_inhibitor"
                "tray"
                "battery"
              ];

              # The middle section is a single grouped box (see style.nix) holding the
              # clock cluster: time, date, weather and mpris.
              modules-center =
                [
                  "custom/time"
                  "custom/date"
                  "custom/weather"
                  # mpris omitted when the noctalia desktop-shell aspect is active (see note below)
                ]
                ++ lib.optional (!user.hasAspect noctalia.entry) "mpris";

              modules-right = [
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

              "custom/date" = {
                exec = ''date +'{"text":"%a","tooltip":"%A, %F"}'';
                tooltip = true;
                interval = 60;
                return-type = "json";
              };

              "custom/time" = {
                exec = "date +'%H:%M'";
                tooltip = false;
                interval = 60;
              };

              "cpu" = {
                interval = 5;
                format = " {usage}%";
                tooltip = true;
                tooltip-format = "CPU: {usage}%";
                justify = "center";
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
                justify = "center";
                format-full = "󰂅";
                tooltip-format-discharging = "{power:>1.0f}W↓ {capacity}%";
                tooltip-format-charging = "{power:>1.0f}W↑ {capacity}%";
                interval = 5;
                on-click = "${pkgs.libnotify |> lib.getExe} -u low \"$(cat /sys/class/power_supply/BAT1/status)\"";
                states = {
                  warning = 20;
                  critical = 10;
                };
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
                interval = 5;
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
