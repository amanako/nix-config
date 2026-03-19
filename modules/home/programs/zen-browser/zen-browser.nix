{ inputs, ... }:

{
  flake.hmModules.zen-browser =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      imports = [ inputs.zen-browser.homeModules.beta ];

      programs.zen-browser = {
        enable = true;
        policies = import ./_policies;
        profiles."*" = {
          extensions = import ./_extensions { inherit pkgs lib inputs; };

          containersForce = true;
          containers = import ./_containers;
          spacesForce = true;
          spaces = import ./_spaces { inherit config; };

          settings = import ./_settings;
          search = {
            force = true;
            default = "ddg";
            privateDefault = "ddg";
            engines = import ./_search-engines { inherit pkgs lib; };
          };
        };
      };
    };
}
