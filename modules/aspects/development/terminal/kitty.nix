{
  den.aspects.terminal.kitty = {
    stylixHMSettings.targets."kitty".enable = false;

    hm = {pkgs, ...}: {
      programs.kitty = {
        enable = true;
        themeFile = "GruvboxMaterialDarkSoft";
        font = {
          name = "VictorMono Nerd Font";
          package = pkgs.nerd-fonts.victor-mono;
          size = 12;
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

        # Allow for the keybinding to serve a dual purpose based on whether text is selected
        keybindings."ctrl+c" = "copy_or_interrupt";
      };
    };
  };
}
