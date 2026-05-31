{
  __findFile,
  inputs,
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

  den.aspects.browsers.zen-browser = {user, ...}: {
    persysUser.directories = [
      ".config/zen/${user.userName}"
    ];

    stylixHome.targets."zen-browser" = {
      enable = false;
      profileNames = ["${user.userName}"];
    };

    homeManager = {
      imports = [inputs.zen-browser.homeModules.twilight];

      programs.zen-browser = {
        enable = true;
        setAsDefaultBrowser = true;
      };
    };
  };
}
