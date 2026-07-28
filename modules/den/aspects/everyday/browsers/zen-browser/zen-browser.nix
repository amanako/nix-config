{
  zen-browser,
  inputs,
  lib,
  ...
}: {
  # Add a namespace accessible under zen-browser, false meaning it's not exposed as flake output
  imports = [(inputs.den.namespace "zen-browser" false)];

  flake-file.inputs.zen-browser.url = "github:0xc000022070/zen-browser-flake";

  zen-browser.full = {
    description = "Full aggregator for the Zen Browser aspects, including all sub-aspects.";

    includes = [
      zen-browser._
      zen-browser.search._
    ];
  };

  zen-browser.entry = {user, ...}: let
    preferedBrowser = user.preferences.browser;
    isZenPrefered = lib.hasPrefix "zen" preferedBrowser;

    # Since binary name remains "zen-twilight" for both twilight and twilight-official
    # variants, strip the "zen-" prefix to get the flake/home-module variant name.
    stripZen =
      if isZenPrefered
      then
        (lib.removePrefix "zen-"
          preferedBrowser)
      else "";
  in {
    description = "Zen Browser — a Firefox-based browser focused on privacy and customization.";

    includes = [
      zen-browser.profileSettingsCollector
    ];

    nushellConfig = {user, ...}:
      lib.optionalString (lib.hasPrefix "zen" user.preferences.browser) ''
        $env.BROWSER = "${user.preferences.browser}"
      '';

    niriSettings = let
      stripOfficial = preferedBrowser |> lib.removePrefix "-official";
    in
      lib.optionalAttrs isZenPrefered {
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

    hm = let
      # The Zen variant whose package we deploy (mirrors the home module below).
      zenVariant =
        if isZenPrefered
        then stripZen
        else "beta";
    in {
      imports = [
        # Defaults to recommended beta version
        inputs.zen-browser.homeModules.${zenVariant}
      ];

      programs.zen-browser = {
        enable = true;
        setAsDefaultBrowser = isZenPrefered;
      };
    };
  };
}
