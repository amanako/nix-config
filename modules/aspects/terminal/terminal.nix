{ inputs, ... }:

{
  flake-file.inputs = {
    yazi.url = "github:sxyazi/yazi";
  };

  den.aspects.terminal = {
    homeManager =
      { pkgs, lib, ... }:
      {
        nixpkgs.overlays = [ inputs.yazi.overlays.default ];

        programs.yazi = {
          enable = true;
          enableFishIntegration = true;
          shellWrapperName = "y";
          keymap = {
            mgr.prepend_keymap = [ ];
          };
          settings = {
            mgr = {
              show_hidden = false;
            };
            opener.edit = [
              {
                run = "nvim \"$@\"";
                block = true;
              }
            ];
          };
        };

        programs.starship = {
          enable = true;
          enableFishIntegration = true;
          settings = {
            "$schema" = "https://starship.rs/config-schema.json";

            format = lib.concatStrings [
              "$username"
              "$hostname"
              "$directory"
              "$git_branch"
              "$git_state"
              "$git_status"
              "$cmd_duration"
              "$line_break"
              "$character"
            ];

            palette = "gruvbox_dark";

            palettes.gruvbox_dark = {
              # this one is more of greenish
              color_blue = "#458588";
              color_aqua = "#689d6a";
              color_main = "#98971a";
              color_orange = "#d65d0e";
              color_purple = "#b16286";
              color_red = "#cc241d";
              color_yellow = "#d79921";
            };

            directory = {
              style = "color_orange";
            };

            git_branch = {
              symbol = "";
              style = "color_aqua";
              format = "[[ $symbol $branch ](color_blue color_aqua)]($style)";
            };

            git_status = {
              style = "color_aqua";
              format = "[[($all_status$ahead_behind )](color_orange colow_yellow)]($style)";
            };

            character = {
              success_symbol = "[ ](bold color_main)";
              error_symbol = "[ ](bold color_red)";
              vimcmd_symbol = "[ ](bold color_purple)";
            };

            cmd_duration = {
              format = "[$duration]($style) ";
            };
          };
        };

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
            background_opacity = 0.95;
            window_padding_width = 4;
            hide_window_decorations = true;
            cursor_trail = 1;
            cursor_trail_start_threshold = 2;
            cursor_trail_decay = "0.15 0.3";
            font_features = "VictorMonoNF-Regular +ss08";
            allow_remote_control = "socket-only";
            listen_on = "unix:/tmp/kitty";
          };

          # Setup for kitty scrollback nvim extension
          # Reference: https://github.com/mikesmithgh/kitty-scrollback.nvim
          actionAliases = {
            "kitty_scrollback_nvim" =
              "kitten '${pkgs.vimPlugins.kitty-scrollback-nvim}/python/kitty_scrollback_nvim.py'";
          };

          keybindings = {
            "kitty_mod+h" = "kitty_scrollback_nvim";
            "kitty_mod+g" = "kitty_scrollback_nvim --config ksb_builtin_last_cmd_output";
          };

          mouseBindings = {
            "ctrl+shift+right" =
              "press ungrabbed combine : mouse_select_command_output : kitty_scrollback_nvim --config ksb_builtin_last_visited_cmd_output";
          };
        };
      };
  };
}
