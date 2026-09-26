{lib, ...}: {
  zen-browser.profileSettingsCollector = {
    # Reference for settings: https://zen-browser-flake.nshard.com

    # Although zen allow for multiple profiles multiple container features supersede that.
    # Therefore, one profile is made supposing multiple containers will be used in case there is a need for separation of context.
    userSettings = {user, ...}: {
      profileName = lib.mkOption {
        type = lib.types.str;
        default = user.userName;
        example = "warrior";
        description = "Name to use for profile in zen-browser.";
      };
    };

    hm = {
      zenProfileSettings,
      zenSearchEngines,
      user,
      lib,
      pkgs,
      inputs',
      config,
      ...
    }: let
      cfg = user.settings.zen-browser.profileSettingsCollector;
    in {
      programs.zen-browser.profiles.${cfg.profileName} =
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
    };
  };
}
