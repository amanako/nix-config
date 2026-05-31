{
  noctalia.plugins.official = {
    homeManager = {lib, ...}: {
      programs.noctalia-shell = {
        plugins = let
          noctaliaPluginURL = "https://github.com/noctalia-dev/noctalia-plugins";
        in {
          sources = [
            {
              enabled = true;
              name = "Official Noctalia Plugins";
              url = noctaliaPluginURL;
            }
          ];

          states = let
            officialPlugins = [
              "battery-actions"
              "clipper"
              "polkit-agent"
              "keybind-cheatsheet"
            ];
          in
            lib.genAttrs officialPlugins (_: {
              enabled = true;
              sourceUrl = noctaliaPluginURL;
            });

          version = 2;
        };

        pluginSettings.clipper.fullscreenMode = true;

        settings.plugins = {
          autoUpdate = true;
          notifyUpdates = true;
        };
      };
    };
  };
}
