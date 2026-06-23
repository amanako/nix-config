{niri, ...}: {
  niri.binds = {
    includes = [
      niri.binds.keyboard-backlight
    ];

    niriSettings = {
      user,
      lib,
      ...
    }: {
      binds = let
        sh = cmd: {action.spawn-sh = cmd;};
        # Generate list with numbers from 1 to 9
        workspaceNumsList =
          8
          |> lib.genList (i: i + 1);

        generatedFocusWorkspace =
          workspaceNumsList
          |> map (val: {
            name = "Mod+${val |> toString}";
            value = {
              action.focus-workspace = val;
            };
          })
          |> builtins.listToAttrs;

        generatedMoveColumn =
          workspaceNumsList
          |> map (val: {
            name = "Mod+Ctrl+${toString val}";
            value = {
              action.move-column-to-workspace = val;
            };
          })
          |> builtins.listToAttrs;

        pref = user.preferences;
      in
        generatedFocusWorkspace
        // generatedMoveColumn
        // {
          "Mod+BracketLeft".action.consume-or-expel-window-left = [];
          "Mod+BracketRight".action.consume-or-expel-window-right = [];
          "Mod+C".action.center-column = [];
          "Mod+F".action.maximize-column = [];

          "Mod+K".action.focus-window-or-workspace-up = [];
          "Mod+J".action.focus-window-or-workspace-down = [];
          "Mod+H".action.focus-column-left = [];
          "Mod+L".action.focus-column-right = [];
          "Mod+Shift+K".action.move-column-to-workspace-up = [];
          "Mod+Shift+J".action.move-column-to-workspace-down = [];
          "Mod+Shift+H".action.move-column-left = [];
          "Mod+Shift+L".action.move-column-right = [];

          "Mod+Up".action.focus-window-or-workspace-up = [];
          "Mod+Down".action.focus-window-or-workspace-down = [];
          "Mod+Left".action.focus-column-left = [];
          "Mod+Right".action.focus-column-right = [];
          "Mod+Shift+Up".action.move-column-to-workspace-up = [];
          "Mod+Shift+Down".action.move-column-to-workspace-down = [];
          "Mod+Shift+Left".action.move-column-left = [];
          "Mod+Shift+Right".action.move-column-right = [];

          "Mod+R".action.switch-preset-column-width-back = [];
          "Mod+Tab".action.toggle-overview = [];

          "Mod+T".action.spawn = pref.term;
          "Mod+B".action.spawn = pref.browser;
          "Mod+N" = sh "${pref.term} -e ${pref.editor}";
          "Mod+Y" = sh "${pref.term} -e ${pref.fileManager}";

          "Mod+Shift+C".action.center-visible-columns = [];
          "Mod+Shift+F".action.fullscreen-window = [];
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
        };
    };
  };
}
