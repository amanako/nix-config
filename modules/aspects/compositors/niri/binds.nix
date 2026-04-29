{
  den.aspects.niri-binds = {host, ...}: {
    homeManager = {
      pkgs,
      lib,
      config,
      ...
    }: let
      variables = config.home.sessionVariables;
      editor = variables.EDITOR;
      term = variables.TERM;
      fileManager = variables.FILE_MANAGER;
      browser = variables.BROWSER;
      sh = cmd: {action.spawn-sh = cmd;};
      keyboardLightScriptPath = lib.optionalAttrs (host.keyboardLightScript.device != null) (
        let
          brightnessCmd = lib.getExe pkgs.brightnessctl;
          inherit (host.keyboardLightScript) device step;
        in
          pkgs.writeShellScriptBin "keyboard-light" ''
            CURR_BRIGHTNESS=$(${brightnessCmd} --device=${device} get)

            case $1 in
              increase)
                NEW_BRIGHTNESS=$(( CURR_BRIGHTNESS + ${toString step} ))
                ;;
              decrease)
                NEW_BRIGHTNESS=$(( CURR_BRIGHTNESS - ${toString step} ))
                ;;
            esac

            ${brightnessCmd} --device=${device} set "$NEW_BRIGHTNESS"
          ''
      );
    in {
      programs.niri.settings.binds =
        {
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

          "Mod+BracketLeft".action.consume-or-expel-window-left = [];
          "Mod+BracketRight".action.consume-or-expel-window-right = [];
          "Mod+C".action.center-column = [];
          "Mod+F".action.maximize-column = [];

          "Mod+K".action.focus-window-or-workspace-up = [];
          "Mod+J".action.focus-window-or-workspace-down = [];
          "Mod+H".action.focus-column-left = [];
          "Mod+L".action.focus-column-right = [];

          "Mod+Up".action.focus-window-or-workspace-up = [];
          "Mod+Down".action.focus-window-or-workspace-down = [];
          "Mod+Left".action.focus-column-left = [];
          "Mod+Right".action.focus-column-right = [];

          "Mod+R".action.switch-preset-column-width-back = [];
          "Mod+Tab".action.toggle-overview = [];

          "Mod+T".action.spawn = term;
          "Mod+B".action.spawn = browser;
          # Use shell wrapper "y" for greater flexibility if yazi is file manager
          "Mod+Y" = let
            shellExe = lib.getExe pkgs.fish;
            fmCmd =
              if fileManager == "yazi"
              then
                lib.escapeShellArgs [
                  shellExe
                  "-ic"
                  "y; exec ${shellExe}"
                ]
              else fileManager;
          in
            sh "${term} -e ${fmCmd}";

          "Mod+N" = sh "${term} -e ${editor}";
          # TODO: Fix script and call
          # "Mod+Ctrl+C" = sh "${config.home.homeDirectory}/nix-config/scripts/cursor-switch";

          "Mod+Shift+C".action.center-visible-columns = [];
          "Mod+Shift+F".action.fullscreen-window = [];
          "Mod+Shift+H".action.move-column-left = [];
          "Mod+Shift+J".action.move-column-to-workspace-down = [];
          "Mod+Shift+K".action.move-column-to-workspace-up = [];
          "Mod+Shift+L".action.move-column-right = [];
          "Mod+Shift+R".action.switch-preset-column-width = [];

          "Mod+Home".action.focus-column-first = [];
          "Mod+End".action.focus-column-last = [];
          "Mod+Ctrl+Home".action.move-column-to-first = [];
          "Mod+Ctrl+End".action.move-column-to-last = [];

          "Mod+Shift+E".action.quit = [];
          "Mod+Shift+Slash".action.show-hotkey-overlay = [];

          "Mod+V".action.toggle-window-floating = [];
          "Mod+Shift+V".action.switch-focus-between-floating-and-tiling = [];

          "Print".action.screenshot = [];
          "Ctrl+Print".action.screenshot-screen = [];
          "Alt+Print".action.screenshot-window = [];

          "Mod+Shift+P".action.power-off-monitors = [];
          "Mod+Q".action.close-window = [];
        }
        // lib.optionalAttrs (host.keyboardLightScript.device != null) {
          "Alt+Up" = sh "${lib.getExe keyboardLightScriptPath} increase";
          "Alt+Down" = sh "${lib.getExe keyboardLightScriptPath} decrease";
        };
    };
  };
}
