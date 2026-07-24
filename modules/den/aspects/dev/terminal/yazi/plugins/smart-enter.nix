{
  den,
  lib,
  ...
}: {
  den.aspects.dev.terminal.yazi.plugins.smart-enter = {
    hm = {
      pkgs,
      user,
      ...
    }:
    # Starship needs to be setup for plugin to work
      lib.optionalAttrs (user.hasAspect den.aspects.dev.shell-tools.starship) {
        programs.yazi = {
          plugins.smart-enter = {
            package = pkgs.yaziPlugins.smart-enter;
          };

          keymap.mgr.prepend_keymap = [
            {
              on = [
                "l"
              ];
              run = "plugin smart-enter";
              desc = "Enter the child directory or open file, smartly";
            }
          ];
        };
      };
  };
}
