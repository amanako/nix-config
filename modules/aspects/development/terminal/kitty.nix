{
  den.aspects.terminal.kitty = {
    stylixHome.targets."kitty".enable = false;
    homeManager = {pkgs, ...}: {
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
          cursor_trail = 1;
          cursor_trail_start_threshold = 2;
          cursor_blink_interval = "-1 ease-in-out";
          cursor_stop_blinking_after = 0;
          cursor_trail_decay = "0.15 0.3";
          font_features = "VictorMonoNF-Regular +ss08";

          allow_remote_control = "socket-only";
          listen_on = "unix:/tmp/kitty";
        };

        # Setup for kitty scrollback nvim extension
        # Reference: https://github.com/mikesmithgh/kitty-scrollback.nvim
        actionAliases = {
          "kitty_scrollback_nvim" = "kitten '${pkgs.vimPlugins.kitty-scrollback-nvim}/python/kitty_scrollback_nvim.py'";
        };

        keybindings = {
          "kitty_mod+h" = "kitty_scrollback_nvim";
          "kitty_mod+g" = "kitty_scrollback_nvim --config ksb_builtin_last_cmd_output";
          # Allow for the keybinding to serve a dual purpose based on whether text is selected
          "ctrl+c" = "copy_or_interrupt";
        };

        mouseBindings = {
          "ctrl+shift+right" = "press ungrabbed combine : mouse_select_command_output : kitty_scrollback_nvim --config ksb_builtin_last_visited_cmd_output";
        };
      };
    };
  };
}
