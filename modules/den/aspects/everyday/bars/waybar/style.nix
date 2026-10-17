{den, ...}: {
  den.aspects.everyday.bars.waybar.style = {
    hm = {
      config,
      lib,
      user,
      ...
    }: let
      colors =
        lib.attrByPath ["lib" "stylix" "colors"]
        den.aspects.everyday.bars.waybar.fallbackPalette
        config;
    in {
      programs.waybar.style = ''
          @define-color bg ${colors.withHashtag.base00};
          @define-color muted ${colors.withHashtag.base01};
          @define-color surface ${colors.withHashtag.base02};
          @define-color dim ${colors.withHashtag.base03};
          @define-color fg ${colors.withHashtag.base05};
          @define-color red ${colors.withHashtag.base08};
          @define-color orange ${colors.withHashtag.base09};
          @define-color gold ${colors.withHashtag.base0A};
          @define-color green ${colors.withHashtag.base0B};
          @define-color teal ${colors.withHashtag.base0C};
          @define-color accent ${colors.withHashtag.base0D};
          @define-color pink ${colors.withHashtag.base0E};

          * {
            font-family: "${user.preferences.monofont.name}";
            font-size: 14px;
            border: none;
            border-radius: 0px;
            margin: 0rem;
            min-height: 0;
            min-width: 0;
          }

          window#waybar  {
            background-color: transparent;
          }


          #waybar > box {
            margin: 0px;
            padding: 8px 6px;
            min-height: 25px;
            border-radius: 12px;
            background-color: @bg;
            box-shadow: none;
          }

          /* The middle section is a single grouped "clock cluster" box: time, date,
             weather and mpris share one rounded container. The individual modules
             inside are made transparent so they blend into this box. */
          .modules-center {
            background-color: @muted;
            border-radius: 10px;
            padding: 4px 2px;
            margin: 2px 0;
          }

          window#waybar.empty .modules-center {
            margin: 0;
            padding: 0;
            border: none;
            background-color: transparent;
          }

          .modules-left,
          .modules-right {
          border-radius: 8px;
          padding: 0 1px;
        }


            button {
              box-shadow: inset 0 -3px transparent;
              border: none;
              border-radius: 0;
              transition: 0.3s ease-in-out;
            }

            button:hover {
              background: inherit;
            }

            #workspaces {
                background-color: transparent;
                margin: 2px 1px;
                padding: 0;
            }

            #workspaces button {
                color: @accent;
                margin: 0 2px;
                padding: 0 6px;
                border-radius: 8px;
                min-width: 20px;
                transition: all 0.2s ease-in-out;
            }

            #workspaces button:hover {
                background-color: @surface;
            }

            #workspaces button.active {
                background-color: @accent;
                color: @bg;
                border-radius: 8px;
            }

            #workspaces button.urgent {
                background-color: @red;
                color: @bg;
            }

            /* bluetooth and network as separate rounded pills (teal = connectivity) */
            #bluetooth,
            #network,
            #network.wifi,
            #network.ethernet {
              color: @bg;
              background-color: alpha(@teal, 1);
              opacity: 1;
              border-radius: 8px;
              margin: 2px 1px;
              padding: 4px 8px;
              min-height: 20px;
            }

            /* font renders the wifi glyph off-center; nudge it 2px left */
            #network,
            #network.wifi,
            #network.ethernet {
              padding: 4px 10px 4px 6px;
            }

            /* no wifi / disconnected = red */
            #network.disconnected {
              color: @bg;
              background-color: @red;
              opacity: 1;
              border-radius: 8px;
              margin: 2px 1px;
              padding: 4px 10px 4px 6px;
              min-height: 20px;
            }

            #tray,
            #idle_inhibitor,
            #memory,
            #cpu,
            #battery,
            #battery.discharging,
            #battery.full,
            #battery.plugged,
            #battery.charging,
            #pulseaudio,
            #pulseaudio.input,
            #pulseaudio.output,
            #custom-weather,
            #custom-clock,
            #custom-updatespacman,
            #custom-screenrecording-indicator,
            #custom-screenrecording-indicator.active,
            #custom-update,
            #custom-omarchy {
              color: @bg;
              background: alpha(@accent, 1);
              opacity: 1;
              border-radius: 8px;
              padding: 0 6px;
              margin: 2px 1px;
            }

            #custom-omarchy {
                color: @bg;
                background-color: @red;
                font-size: 16px;
                padding: 0 12px;
            }

            /* bottom-section recoloring: backlight = yellow */
            #backlight {
              color: @bg;
              background-color: @gold;
              border-radius: 8px;
              padding: 0 10px 0 5px;
              margin: 2px 1px;
            }

            /* power-profiles-daemon: red = performance, orange = balanced, green = power-saver */
            #power-profiles-daemon {
              color: @bg;
              background-color: alpha(@orange, 1);
              border-radius: 8px;
              padding: 0 6px;
              margin: 2px 1px;
            }

            #power-profiles-daemon.balanced {
              background-color: alpha(@orange, 1);
              color: @bg;
            }

            #power-profiles-daemon.performance {
              background-color: @red;
              color: @bg;
            }

            #power-profiles-daemon.power-saver {
              background-color: @green;
              color: @bg;
            }


            #clock,
            #custom-weather,
            #mpris {
              color: @fg;
              background-color: transparent;
              border-radius: 8px;
              margin: 1px 1px;
              padding: 0 4px;
            }

            #backlight,
            #pulseaudio {
              padding: 0 10px 0 5px;
            }

            #pulseaudio.muted {
              background-color: @red;
              color: @bg;
            }

            #pulseaudio.critical {
              background-color: @red;
              color: @bg;
            }

            #custom-update,
            #custom-updatespacman {
              background-color: @muted;
            }

            #idle_inhibitor.deactivated {
            font-size: 14px;
            padding: 0 10px 0 5px;
            background-color: @accent;
            }

            #idle_inhibitor.activated {
              font-size: 14px;
              background-color: @gold;
                color: @bg;
                padding: 0 10px 0 5px;
            }

            /* memory/cpu: neutral pills, gold on warning, red on critical */
            #memory,
            #cpu {
              background-color: @surface;
              color: @fg;
              padding: 3px 2px;
              margin: 2px 1px;
            }

            #memory.warning,
            #cpu.warning {
              background-color: @gold;
              color: @bg;
            }

            #memory.critical,
            #cpu.critical {
              background-color: @red;
              color: @bg;
            }

            /* battery: green when full, blue = sufficient charge (above warning),
               gold = low charge, red = critical. Charging state is ignored. */
            #battery.full:not(.warning):not(.critical) {
              background-color: @green;
              color: @bg;
            }
            #battery:not(.warning):not(.critical) {
              background-color: @accent;
              color: @bg;
            }
            #battery.warning:not(.critical) {
              background-color: @gold;
              color: @bg;
            }
            #battery.critical {
              background-color: @red;
              color: @bg;
            }

            #custom-voxtype,
            #custom-idle-indicator,
            #custom-notification-silencing-indicator {
                padding: 0 6px;
                margin: 2px 1px;
                border-radius: 8px;
                min-width: 10px;
            }

            #custom-voxtype,
            #custom-idle-indicator.active,
            #custom-notification-silencing-indicator.active {
              color: @red;
              opacity: 1;
            }

            .hidden {
              opacity: 0;
            }

            tooltip {
             padding: 4px;
             background-color: @muted;
             font-size: 10px;
             border: 1px solid @accent;
             border-radius: 6px;

            }
            tooltip label {
                color: alpha(@fg, 1);
                font-weight: normal;
            }

            /* tray / context menus */
            menu {
              background-color: @muted;
              color: @fg;
              border: 1px solid @accent;
              border-radius: 8px;
              padding: 4px 0;
            }

            menuitem {
              color: @fg;
              padding: 2px 12px;
              min-height: 0;
            }

            menuitem:hover {
              background-color: @accent;
              color: @bg;
            }

            menuitem:hover label {
              color: @bg;
            }

            menuitem:disabled label {
              color: @dim;
            }

            /* tray icon states: red tint when an item wants attention */
            #tray > .passive {
              -gtk-icon-effect: dim;
            }

            #tray > .needs-attention {
              -gtk-icon-effect: highlight;
              background-color: alpha(@red, 0.3);
              border-radius: 4px;
            }


            #custom-separator2,
            #custom-separator {
              opacity: 0.25;
              padding-bottom: 0px;
              padding-top: 1px;
              padding-left: 3px;
              padding-right: 3px;
              font-size: 10px;
              color: @fg;
            }

            #custom-waybar-position {
                background-color: @pink;
                color: @bg;
                padding: 0 6px;
                margin: 2px 1px;
                border-radius: 8px;
                min-width: 10px;
            }

            #custom-waybar-position:hover {
                background-color: alpha(@pink, 0.75);
            }


            /* Specific animation Module */

            #custom-screenrecording-indicator {
              animation-timing-function: linear;
              animation-iteration-count: infinite;
              animation-direction: alternate;
              color: transparent;
            }

            #custom-screenrecording-indicator.active {
              background-color: transparent;
              padding: 0 13px 0 10px;
              color: @red;
              animation-name: blink-recording;
              animation-duration: 0.5s;
            }

            @keyframes blink-recording {
                to {
                    color: @bg;
                }
            }

            #mpris {
                color: @fg;
                background-color: transparent;
                margin: 1px 1px;
                padding: 0 4px;
                border-radius: 8px;
                min-height: 20px;
                font-weight: 900;
            }

            #mpris.playing {
                color: @gold;
            }

            #mpris.paused {
                color: @accent;
            }

            @keyframes blink2 {
              to {
                background-color: transparent;
                color: @red;
              }
            }

            /* blink only while discharging on battery power, never on charger */
            #battery.critical:not(.charging):not(.plugged) {
              background-color: @red;
              color: @bg;
              animation-name: blink2;
              animation-duration: 0.5s;
              animation-timing-function: steps(12);
              animation-iteration-count: infinite;
              animation-direction: alternate;
            }
      '';
    };
  };
}
