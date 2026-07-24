{
  den.aspects.dev.terminal.yazi.plugins.chmod = {
    hm = {pkgs, ...}: {
      programs.yazi = {
        plugins.chmod.package = pkgs.yaziPlugins.chmod;

        keymap.mgr.prepend_keymap = [
          {
            on = [
              "c"
              "m"
            ];
            run = "plugin chmod";
            desc = "Change mod on selected files";
          }
        ];
      };
    };
  };
}
