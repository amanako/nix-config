{
  den.aspects.everyday.bars.waybar.style = {
    hm.programs.waybar.style = ''
        @define-color bg #32302f;
        @define-color fg #d4be98;
        @define-color accent #7daea3;
        @define-color red #ea6962;
        @define-color gold #d8a657;
        @define-color pink #d3869b;
        @define-color muted #282828;

        * {
          font-family: "VictorMono Nerd Font";
          font-size: 14px;
          border: none;
          border-radius: 0px;
          margin: 0rem 0rem 0rem 0rem;
          min-height: 0;
          min-width: 0;
        }

        window#waybar  {
          background-color: transparent;
        }


        #waybar > box {
          margin: 0;
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
              color: @fg;
              margin: 0 2px;
              padding: 0 6px;
              border-radius: 8px;
              min-width: 20px;
              transition: all 0.2s ease-in-out;
          }

          #workspaces button.active {
              background-color: @red;
              color: @bg;
              border-radius: 8px;
          }

          #workspaces button.empty {
              color: @accent;
              background-color: transparent;
              min-width: 20px;
              padding: 0 6px;
          }

          #workspaces button.empty.active {
              background-color: alpha(@red, 0.6);
              color: @bg;
              min-width: 20px;
              padding: 0 6px;
          }

          #workspaces button:hover {
              background-color: alpha(@gold, 0.4);
              color: @bg;
          }

          #workspaces button.empty:hover {
              background-color: alpha(@accent, 0.3);
              color: @fg;
          }

          #workspaces button.urgent {
              background-color: @red;
              color: @bg;
          }

          /* bluetooth and network as separate rounded pills (pink) */
          #bluetooth,
          #network,
          #network.wifi,
          #network.ethernet {
            color: @bg;
            background-color: alpha(@pink, 1);
            opacity: 1;
            border-radius: 8px;
            margin: 2px 1px;
            padding: 0 4px;
          }

          /* no wifi / disconnected = red */
          #network.disconnected {
            color: @bg;
            background-color: @red;
            opacity: 1;
            border-radius: 8px;
            margin: 2px 1px;
            padding: 0 4px;
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
          #power-profiles-daemon.performance,
          #power-profiles-daemon.balanced,
          #power-profiles-daemon.power-saver,
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

          /* bottom-section recoloring: backlight = yellow, power-profiles-daemon = pink */
          #backlight {
            color: @bg;
            background-color: @gold;
            border-radius: 8px;
            padding: 0 10px 0 5px;
            margin: 2px 1px;
          }

          #power-profiles-daemon {
            color: @bg;
            background-color: alpha(@pink, 1);
            border-radius: 8px;
            padding: 0 6px;
            margin: 2px 1px;
          }

          /* balanced profile stays pink; performance/power-saver keep their colors below */
          #power-profiles-daemon.balanced {
            background-color: alpha(@pink, 1);
          }


          #custom-clock,
          #custom-weather,
          #custom-date,
          #custom-time,
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
            background-color: @red;
              color: @bg;
              padding: 0 10px 0 5px;
          }

          /* memory/cpu: icon stacked over value via <br/> in format; narrow pill, tall */
          #memory,
          #cpu {
            background-color: @gold;
            padding: 3px 2px;
            margin: 2px 1px;
          }

          /* battery: blue when discharging, red when charging/plugged/full */
          #battery.discharging {
            background-color: @accent;
            color: @bg;
          }
          #battery,
          #battery.charging,
          #battery.plugged,
          #battery.full {
            background-color: @red;
            color: @bg;
          }

          #power-profiles-daemon.performance {
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
           background: @bg;
           font-size: 10px;
           border: 1px solid @accent;
           border-radius: 6px;

          }
          tooltip label {
              color: alpha(@fg, 1);
              font-weight: normal;
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
              background-color: @red;
              color: @bg;
              padding: 0 6px;
              margin: 2px 1px;
              border-radius: 8px;
              min-width: 10px;
          }

          #custom-waybar-position:hover {
              background-color: @red;
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
            color: #eb7087;
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

          #network.disconnected,
          #battery.warning {
            color: @bg;
          }

          @keyframes blink2 {
            to {
              background-color: transparent;
              color: @red;
            }
          }

          #battery.critical,
          #battery.critical:not(.charging) {
            background-color: @red;
            color: @bg;
            animation-name: blink2;
            animation-duration: 0.5s;
            animation-timing-function: steps(12);
            animation-iteration-count: infinite;
            animation-direction: alternate;
          }

          #memory.warning,
          #cpu.warning {
              color: @red;
          }
    '';
  };
}
