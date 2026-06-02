{
  __findFile,
  inputs,
  lib,
  ...
}: {
  # Add a namespace accessible under zen-browser, false meaning it's not exposed as flake output
  imports = [(inputs.den.namespace "zen-browser" false)];

  flake-file.inputs = {
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    firefox-addons.url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
  };

  den.aspects.browsers.zen-browser-full.includes = [
    <browsers/zen-browser>
    <zen-browser/containers>
    <zen-browser/extensions>
    <zen-browser/policies>
    <zen-browser/settings>
    <zen-browser/spaces>
    <zen-browser/search>
  ];

  den.aspects.browsers.zen-browser = {user, ...}: let
    browser = user.preferences.browser;
    isZen = lib.hasPrefix "zen" browser;

    # Since binary name remains "zen-twilight" for both twilight and twilight-official
    # variants, strip "-official" part when passing command to niri.
    stripZen =
      if isZen
      then
        (lib.removePrefix "zen-"
          browser)
      else "";
    stripOfficial = lib.removeSuffix "-official" browser;
  in {
    niriSpawnAtStartup = lib.optionalAttrs isZen {
      command = [stripOfficial];
    };

    persysUser.directories = [
      ".config/zen/${user.userName}"
    ];

    stylixHome.targets."zen-browser" = {
      enable = false;
      profileNames = ["${user.userName}"];
    };

    homeManager = {
      imports = [
        # Defaults to recommended beta version
        inputs.zen-browser.homeModules.${
          if isZen
          then stripZen
          else "beta"
        }
      ];

      programs.zen-browser = {
        enable = true;
        setAsDefaultBrowser = true;
      };
    };
  };
}
