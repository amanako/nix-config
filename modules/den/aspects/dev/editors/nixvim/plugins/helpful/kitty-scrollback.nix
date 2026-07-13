{den, ...}: {
  nixvim.plugins.kitty-scrollback = {user, ...}: {
    hm = {
      pkgs,
      lib,
      ...
    }: {
      programs = {
        nixvim.plugins.kitty-scrollback.enable = true;

        # Additional setup and wiring for kitty
        # Reference: https://github.com/mikesmithgh/kitty-scrollback.nvim
        kitty = {
          # Since both aspects configure same settings for kitty in different ways.
          # Let kitty-scrollback only use this recommended settings when user doesn't enable direnv.
          settings = lib.mkIf (!
                  (den.aspects.dev.shell-tools.direnv
            |> user.hasAspect)) {
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
