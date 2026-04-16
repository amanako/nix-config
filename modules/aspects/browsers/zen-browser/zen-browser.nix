{ inputs, ... }:

{
  flake-file.inputs = {
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  den.aspects.browsers._.zen-browser = {
    homeManager =
      {
        pkgs,
        lib,
        config,
        ...
      }:
      {
        imports = [ inputs.zen-browser.homeModules.beta ];

        stylix.targets.zen-browser.profileNames = [ "*" ];

        programs.zen-browser = {
          enable = true;
          setAsDefaultBrowser = true;

          policies = import ./_policies;
          profiles."*" = {
            extensions = import ./_extensions { inherit pkgs lib inputs; };

            containersForce = true;
            containers = import ./_containers;
            spacesForce = true;
            spaces = import ./_spaces { inherit config; };

            settings = import ./_settings { inherit lib; };
            search = {
              force = true;
              default = "ddg";
              privateDefault = "ddg";
              engines = import ./_search-engines { inherit pkgs lib; };
            };
          };
        };
      };
  };
}
