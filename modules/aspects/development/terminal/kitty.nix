{
  den.aspects.terminal.kitty = {
    stylixHMSettings.targets."kitty".enable = false;

    niriSettings.binds = {
      "Mod+W".action.spawn-sh = "kitten quick-access-terminal";
    };

    hm = {pkgs, ...}: {
      programs.kitty = {
        enable = true;
        themeFile = "GruvboxMaterialDarkSoft";
        font = {
          name = "VictorMono Nerd Font";
          package = pkgs.nerd-fonts.victor-mono;
          size = 14;
        };

        enableGitIntegration = true;
        shellIntegration.enableFishIntegration = true;
        shellIntegration.mode = "enabled";

        settings = {
          confirm_os_window_close = -1;
          # background_opacity = lib.mkDefault 0.95;
          # background_blur = 10;
          window_padding_width = 4;
          hide_window_decorations = true;

          font_features = "VictorMonoNF-Regular +ss08";

          # Cursor movement
          cursor_trail = 1;
          cursor_trail_start_threshold = 2;
          cursor_blink_interval = "-1 ease-in-out";
          cursor_stop_blinking_after = 0;
          cursor_trail_decay = "0.15 0.3";
        };

        keybindings = {
          # Allow for the keybinding to serve a dual purpose based on whether text is selected
          "ctrl+c" = "copy_or_interrupt";

          # Tell new tabs and windows to start in same directory
          "ctrl+shift+t" = "new_tab_with_cwd";
          "ctrl+shift+enter" = "new_window_with_cwd";

          "Alt+h" = "previous_tab";
          "Alt+l" = "next_tab";

          "Alt+j" = "previous_window";
          "Alt+k" = "next_window";
        };

        quickAccessTerminalConfig = {
          lines = 10;
          columns = 60;
          hide_on_focus_loss = true;
        };
      };
    };
  };
}
