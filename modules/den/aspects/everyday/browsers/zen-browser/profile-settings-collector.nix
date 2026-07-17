{
  zen-browser.profileSettingsCollector = {
    # Reference for settings: https://zen-browser-flake.nshard.com

    hm = {
      zenProfileSettings,
      zenSearchEngines,
      user,
      lib,
      pkgs,
      inputs',
      config,
      ...
    }: {
      programs.zen-browser.profiles.${user.userName} =
        zenProfileSettings
        # Handle function by providing required lambda parameters
        # Handle as static aspects otherwise
        |> map (
          settingAspect:
            if builtins.isFunction settingAspect
            then settingAspect {inherit pkgs lib inputs' zenSearchEngines;}
            else settingAspect
        )
        |> lib.foldl lib.recursiveUpdate {}
        |> lib.recursiveUpdate
        {
          # These settings should be in sync
          bookmarks.force = config.programs.zen-browser.policies.NoDefaultBookmarks;
        };
      #
      #
    };
  };
}
