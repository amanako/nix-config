{ pkgs, lib, config, inputs, ... }:

{
	imports = [ inputs.zen-browser.homeModules.beta ];

	programs.zen-browser = {
		enable = true;
    policies = import ./policies;
    profiles."*" = {
      extensions = import ./extensions { inherit pkgs lib inputs; };

      containersForce = true;
      containers = import ./containers;
      spacesForce = true;
      spaces = import ./spaces { inherit config; };

      settings = import ./settings;
      search = {
        force = true;
        default = "ddg";
        privateDefault = "ddg";
        engines = import ./search-engines { inherit pkgs; };
      };
    };
	};
}
