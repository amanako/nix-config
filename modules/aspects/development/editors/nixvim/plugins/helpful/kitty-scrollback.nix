{
  nixvim.plugins.kitty-scrollback = {user, ...}: {
    homeManager = {pkgs, ...}: {
      programs = {
        nixvim.plugins.kitty-scrollback.enable = true;

        # Additional setup and wiring for kitty
        # Reference: https://github.com/mikesmithgh/kitty-scrollback.nvim
        kitty = {
          settings = {
            allow_remote_control = "socket-only";
            listen_on = "unix:/tmp/kitty";
          };
          actionAliases."kitty_scrollback_nvim" = "kitten '${pkgs.vimPlugins.kitty-scrollback-nvim}/python/kitty_scrollback_nvim.py'";

          keybindings = {
            "kitty_mod+h" = "kitty_scrollback_nvim";
            "kitty_mod+g" = "kitty_scrollback_nvim --config ksb_builtin_last_cmd_output";
          };
          mouseBindings."ctrl+shift+right" = "press ungrabbed combine : mouse_select_command_output : kitty_scrollback_nvim --config ksb_builtin_last_visited_cmd_output";
        };
      };
    };
  };
}
