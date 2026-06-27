{
  inputs,
  lib,
  ...
}: {
  # Add a namespace accessible under zen-browser, false meaning it's not exposed as flake output
  imports = [(inputs.den.namespace "zen-browser" false)];

  flake-file.inputs.zen-browser.url = "github:0xc000022070/zen-browser-flake";

  zen-browser.entry = {user, ...}: let
    preferedBrowser = user.preferences.browser;
    isZenPrefered = lib.hasPrefix "zen" preferedBrowser;

    # Since binary name remains "zen-twilight" for both twilight and twilight-official
    # variants, strip "-official" part when passing command to niri.
    stripZen =
      if isZenPrefered
      then
        (lib.removePrefix "zen-"
          preferedBrowser)
      else "";
    stripOfficial = lib.removeSuffix "-official" preferedBrowser;
  in {
    niriSettings = lib.optionalAttrs isZenPrefered {
      spawn-at-startup = [
        {
          command = [stripOfficial];
        }
      ];
    };

    persistUser.directories = [
      ".config/zen/${user.userName}"
    ];

    stylixHMSettings.targets."zen-browser" = {
      enable = true;
      profileNames = ["${user.userName}"];
    };

    hm = {
      imports = [
        # Defaults to recommended beta version
        inputs.zen-browser.homeModules.${
          if isZenPrefered
          then stripZen
          else "beta"
        }
      ];

      programs.zen-browser = {
        enable = true;
        setAsDefaultBrowser = isZenPrefered;
      };
    };
  };
}
