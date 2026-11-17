{
  den,
  lib,
  ...
}: {
  den.aspects.dev.terminal.yazi.plugins.starship = {
    description = "Yazi plugin to render Starship prompt as the status line.";

    hm = {
      pkgs,
      user,
      ...
    }:
    # Starship needs to be setup for plugin to work
      lib.optionalAttrs (user.hasAspect den.aspects.dev.tools.starship) {
        programs.yazi.plugins.starship = {
          package = pkgs.yaziPlugins.starship;
          setup = true;
        };
      };
  };
}
