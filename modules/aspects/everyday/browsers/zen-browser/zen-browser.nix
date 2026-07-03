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
    includes = [
      zen-browser._
      zen-browser.search._
    ];
  };

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
    includes = [
      zen-browser.userSettingsCollector
    ];

    niriSettings = lib.optionalAttrs isZenPrefered {
      spawn-at-startup = [
        {
          command = [stripOfficial];
        }
      ];
    };

    persistUser = let
      basePath = ".config/zen/${user.userName}";
      dirs = [
        # "sessionstore-backups"
        "settings"
        "storage"
        "zen-sessions-backup"
      ];

      files = [
        # "sessionstore.jsonlz4"

        # Cookies
        "cookies.sqlite"

        # Favicons
        "favicons.sqlite"

        # Logins and encryption
        "key4.db"
        "logins.db"
        "logins.json"

        # Bookmarks and browsing history
        "places.sqlite"
        "prefs.js"

        # Store data related to web applications, such as local storage for cookies, preferences, and other information that web apps may need to function properly
        "webappsstore.sqlite"

        # Zen essentials
        "zen-live-folders.jsonlz4"
        # "zen-sessions.jsonlz4"
      ];
    in {
      directories =
        dirs
        |> map (dir: basePath + "/" + dir);

      files =
        files
        |> map (file: basePath + "/" + file);
    };

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
