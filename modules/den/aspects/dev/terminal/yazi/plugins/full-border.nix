{
  den.aspects.dev.terminal.yazi.plugins.full-border = {
    hm = {pkgs, ...}: {
      programs.yazi.plugins.full-border = {
        package = pkgs.yaziPlugins.full-border;
        setup = true;
      };
    };
  };
}
