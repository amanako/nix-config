{
  den.aspects.dev.terminal.yazi.plugins.full-border = {
    description = "Yazi plugin to add a full border around the UI.";

    hm = {pkgs, ...}: {
      programs.yazi.plugins.full-border = {
        package = pkgs.yaziPlugins.full-border;
        setup = true;
      };
    };
  };
}
