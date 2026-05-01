{
  inputs,
  zen-browser,
  ...
}: {
  flake-file.inputs = {
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    firefox-addons.url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
  };

  den.aspects.browsers._.zen-browser = {
    persysUser = {
      directories = [
        ".config/zen/*"
      ];
    };

    includes = [
      zen-browser.containers
      zen-browser.extensions
      zen-browser.policies
      zen-browser.settings
      zen-browser.spaces
      zen-browser.search
    ];

    homeManager = {
      imports = [inputs.zen-browser.homeModules.twilight];

      stylix.targets.zen-browser.profileNames = ["*"];

      programs.zen-browser = {
        enable = true;
        setAsDefaultBrowser = true;
      };
    };
  };
}
